//
//  VideoCamera.swift
//  DTLiving
//
//  Created by Dan Jiang on 2020/2/28.
//  Copyright © 2020 Dan Thought Studio. All rights reserved.
//

import AVFoundation
import CocoaLumberjack

class VideoCamera: VideoOutput {
    
    enum Position {
        case front
        case back
        
        var title: String {
            switch self {
            case .front:
                return "Front"
            case .back:
                return "Back"
            }
        }
        
        static var all: [Position] {
            return [.front, .back]
        }
    }
    
    var backgroundColorRed: CGFloat = 0.0
    var backgroundColorGreen: CGFloat = 0.0
    var backgroundColorBlue: CGFloat = 0.0
    var backgroundColorAlpha: CGFloat = 1.0

    private var position: Position
    private var presets: [AVCaptureSession.Preset]
    private var frameRate: Int

    private enum SessionSetupResult {
        case success
        case notAuthorized
        case configurationFailed
    }

    private var setupResult: SessionSetupResult = .success
    private let sessionQueue = DispatchQueue(label: "camera session queue", attributes: [], target: nil)
    private let session = AVCaptureSession()
    private var videoDeviceInput: AVCaptureDeviceInput?
    private let videoDataOutputQueue = DispatchQueue(label: "camera video data output queue", attributes: [], target: nil)
    private let videoDataOutput = AVCaptureVideoDataOutput()
    
    private let semaphore = DispatchSemaphore(value: 1)
    private var capturePaused = false
    
    private var program: ShaderProgramObject?
    private var positionSlot = GLuint()
    private var texturePositionSlot = GLuint()
    private var textureUniform = GLint()
    private var squareVertices: [GLfloat] = [
        -1, -1,
        1, -1,
        -1, 1,
        1, 1
    ]
    private var textureVertices: [GLfloat] = [
        0, 0,
        1, 0,
        0, 1,
        1, 1
    ]

    var outputImageOrientation: UIInterfaceOrientation = .portrait {
        didSet {
            updateOrientationSendToTargets()
        }
    }
    var horizontallyMirrorRearFacingCamera: Bool = false {
        didSet {
            updateOrientationSendToTargets()
        }
    }
    var horizontallyMirrorFrontFacingCamera: Bool = false {
        didSet {
            updateOrientationSendToTargets()
        }
    }
    // rotate byself
    private var internalRotation: VideoRotation = .noRotation {
        didSet {
            textureVertices = textureCoordinates(for: internalRotation)
        }
    }
    // rotate by next target
    private var outputRotation: VideoRotation = .noRotation

    init(position: Position, presets: [AVCaptureSession.Preset] = [.low], frameRate: Int = 24) {
        self.position = position
        self.presets = presets
        self.frameRate = frameRate
     
        super.init()
        
        authorizeCamera()
        createShaderProgram()
        updateOrientationSendToTargets()
    }

    override func addTarget(_ target: VideoInput, at index: Int) {
        super.addTarget(target, at: index)
        target.setInputRotation(outputRotation, at: index)
    }
    
    func startCapture() {
        sessionQueue.async { [weak self] in
            guard let self = self else { return }
            switch self.setupResult {
            case .success:
                self.session.startRunning()
            case .notAuthorized:
                DDLogError("Could not start session running: camera not authorized")
            case .configurationFailed:
                DDLogError("Could not start session running: session configuration failed")
            }
        }
    }
    
    func stopCaputre() {
        sessionQueue.async { [weak self] in
            guard let self = self else { return }
            if self.setupResult == .success {
                self.session.stopRunning()
            }
        }
    }
    
    func pauseCapture() {
        capturePaused = true
    }
    
    func resumeCapture() {
        capturePaused = false
    }
    
    func rotateCamera() {
        sessionQueue.async { [weak self] in
            self?.reconfigureSession()
        }
    }
        
    private func authorizeCamera() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            break
        case .notDetermined:
            sessionQueue.suspend()
            AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
                guard let self = self else { return }
                if !granted {
                    self.setupResult = .notAuthorized
                }
                self.sessionQueue.resume()
            }
        default:
            setupResult = .notAuthorized
        }
        
        sessionQueue.async { [weak self] in
            self?.configureSession()
        }
    }
    
    private func createShaderProgram() {
        VideoContext.sharedProcessingContext.sync {
            let program = ShaderProgramObject(vertexShader: "effect_vertex", fragmentShader: "effect_fragment")
            positionSlot = program.attributeLocation("a_position")
            texturePositionSlot = program.attributeLocation("a_texcoord")
            textureUniform = program.uniformLocation("u_texture")
            self.program = program
        }
    }
    
    private func reconfigureSession() {
        if setupResult != .success {
            return
        }
        
        switch position {
        case .front:
            position = .back
        case .back:
            position = .front
        }
        
        session.beginConfiguration()
        
        guard let videoDevice = configVideoDevice() else {
            DDLogError("Could not find video device")
            setupResult = .configurationFailed
            session.commitConfiguration()
            return
        }
        
        configSessionPreset(for: videoDevice)
        configSessionInput(for: videoDevice)
        configVideoFrameRate(for: videoDevice)
        
        session.commitConfiguration()
        
        updateOrientationSendToTargets()
    }

    private func configureSession() {
        if setupResult != .success {
            return
        }
        
        session.beginConfiguration()
        
        guard let videoDevice = configVideoDevice() else {
            DDLogError("Could not find video device")
            setupResult = .configurationFailed
            session.commitConfiguration()
            return
        }
        
        configSessionPreset(for: videoDevice)
        configSessionInput(for: videoDevice)
        configSessionOutput()
        configVideoFrameRate(for: videoDevice)
        
        session.commitConfiguration()
    }

    private func configVideoDevice() -> AVCaptureDevice? {
        var defaultVideoDevice: AVCaptureDevice?
        var backCameraDevice: AVCaptureDevice?
        var frontCameraDevice: AVCaptureDevice?
        for cameraDevice in AVCaptureDevice.devices(for: .video) {
            if cameraDevice.position == .back {
                backCameraDevice = cameraDevice
            }
            if cameraDevice.position == .front {
                frontCameraDevice = cameraDevice
            }
        }
        if position == .back {
            if let backCameraDevice = backCameraDevice {
                defaultVideoDevice = backCameraDevice
            } else {
                defaultVideoDevice = frontCameraDevice
                position = .front
            }
        } else {
            if let frontCameraDevice = frontCameraDevice {
                defaultVideoDevice = frontCameraDevice
            } else {
                defaultVideoDevice = backCameraDevice
                position = .back
            }
        }
        return defaultVideoDevice
    }

    private func configSessionPreset(for videoDevice: AVCaptureDevice) {
        for preset in presets {
            if videoDevice.supportsSessionPreset(preset),
                session.canSetSessionPreset(preset) {
                session.sessionPreset = preset
                break
            }
        }
    }
    
    private func configSessionInput(for videoDevice: AVCaptureDevice) {
        do {
            if let videoDeviceInput = videoDeviceInput {
                session.removeInput(videoDeviceInput)
            }
            let videoDeviceInput = try AVCaptureDeviceInput(device: videoDevice)
            if session.canAddInput(videoDeviceInput) {
                session.addInput(videoDeviceInput)
                self.videoDeviceInput = videoDeviceInput
            } else {
                DDLogError("Could not add video device input to the session")
                setupResult = .configurationFailed
                session.commitConfiguration()
                return
            }
        } catch {
            DDLogError("Could not create video device input: \(error)")
            setupResult = .configurationFailed
            session.commitConfiguration()
            return
        }
    }
    
    private func configSessionOutput() {
        session.removeOutput(videoDataOutput)
        videoDataOutput.alwaysDiscardsLateVideoFrames = false
        videoDataOutput.videoSettings = [String(kCVPixelBufferPixelFormatTypeKey): kCVPixelFormatType_32BGRA]
        videoDataOutput.setSampleBufferDelegate(self, queue: videoDataOutputQueue)
        if session.canAddOutput(videoDataOutput) {
            session.addOutput(videoDataOutput)
        } else {
            DDLogError("Could not add video data output to the session")
            setupResult = .configurationFailed
            session.commitConfiguration()
            return
        }
    }
    
    private func configVideoFrameRate(for videoDevice: AVCaptureDevice) {
        let desiredFrameRate = frameRate
        var isFrameRateSupported = false
        for range in videoDevice.activeFormat.videoSupportedFrameRateRanges {
            if Double(desiredFrameRate) <= range.maxFrameRate,
                Double(desiredFrameRate) >= range.minFrameRate {
                isFrameRateSupported = true
            } else {
                DDLogError("Could not config video device frame rate: frame rate is out of range")
            }
        }
        if isFrameRateSupported {
            do {
                try videoDevice.lockForConfiguration()
                videoDevice.activeVideoMinFrameDuration = CMTime(value: 1, timescale: CMTimeScale(desiredFrameRate))
                videoDevice.activeVideoMaxFrameDuration = CMTime(value: 1, timescale: CMTimeScale(desiredFrameRate))
                videoDevice.unlockForConfiguration()
            } catch {
                DDLogError("Could not config video device frame rate: \(error)")
            }
        }
    }
    
    private func updateOrientationSendToTargets() {
        VideoContext.sharedProcessingContext.sync {
            outputRotation = .noRotation
            if position == .back {
                if horizontallyMirrorRearFacingCamera {
                    switch outputImageOrientation {
                    case .portrait:
                        internalRotation = .rotateRightFlipVertical
                    case .portraitUpsideDown:
                        internalRotation = .rotate180
                    case .landscapeLeft:
                        internalRotation = .flipHorizonal
                    case .landscapeRight:
                        internalRotation = .flipVertical
                    default:
                        internalRotation = .noRotation
                    }
                } else {
                    switch outputImageOrientation {
                    case .portrait:
                        internalRotation = .rotateRight
                    case .portraitUpsideDown:
                        internalRotation = .rotateLeft
                    case .landscapeLeft:
                        internalRotation = .rotate180
                    case .landscapeRight:
                        internalRotation = .noRotation
                    default:
                        internalRotation = .noRotation
                    }
                }
            } else {
                if horizontallyMirrorFrontFacingCamera {
                    switch outputImageOrientation {
                    case .portrait:
                        internalRotation = .rotateRightFlipVertical
                    case .portraitUpsideDown:
                        internalRotation = .rotateRightFlipHorizontal
                    case .landscapeLeft:
                        internalRotation = .flipHorizonal
                    case .landscapeRight:
                        internalRotation = .flipVertical
                    default:
                        internalRotation = .noRotation
                    }
                } else {
                    switch outputImageOrientation {
                    case .portrait:
                        internalRotation = .rotateRight
                    case .portraitUpsideDown:
                        internalRotation = .rotateLeft
                    case .landscapeLeft:
                        internalRotation = .noRotation
                    case .landscapeRight:
                        internalRotation = .rotate180
                    default:
                        internalRotation = .noRotation
                    }
                }
            }
        }
        
        for (index, target) in targets.enumerated() {
            target.setInputRotation(outputRotation, at: targetTextureIndices[index])
        }
    }
    
    private func updateTargetsWithTexture(bufferWidth: Int, bufferHeight: Int, currentTime: CMTime) {
        guard let outputFrameBuffer = outputFrameBuffer else { return }
        
        for (index, target) in targets.enumerated() {
            if target.enabled {
                let textureIndex = targetTextureIndices[index]
                target.setInputFrameBuffer(outputFrameBuffer, at: textureIndex)
                target.setInputRotation(outputRotation, at: textureIndex)
                target.setInputSize(CGSize(width: bufferWidth, height: bufferHeight), at: textureIndex)
            }
        }
        
        outputFrameBuffer.unlock()
        self.outputFrameBuffer = nil
        
        for (index, target) in targets.enumerated() {
            if target.enabled {
                let textureIndex = targetTextureIndices[index]
                target.newFrameReady(at: currentTime, at: textureIndex)
            }
        }
    }
    
    private func processVideo(with sampleBuffer: CMSampleBuffer) {
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
        
        let currentTime = CMSampleBufferGetPresentationTimeStamp(sampleBuffer)
        let bufferWidth = CVPixelBufferGetWidth(pixelBuffer)
        let bufferHeight = CVPixelBufferGetHeight(pixelBuffer)
        var rotatedBufferWidth = bufferWidth
        var rotatedBufferHeight = bufferHeight
        if VideoRotationNeedSwapWidthAndHeight(internalRotation) {
            rotatedBufferWidth = bufferHeight
            rotatedBufferHeight = bufferWidth
        }
        
        VideoContext.sharedProcessingContext.useAsCurrentContext()
        
        var inputTexture: CVOpenGLESTexture!
        let textureCache = VideoContext.sharedProcessingContext.textureCache
        let resultCode = CVOpenGLESTextureCacheCreateTextureFromImage(kCFAllocatorDefault,
                                                                      textureCache,
                                                                      pixelBuffer,
                                                                      nil,
                                                                      GLenum(GL_TEXTURE_2D),
                                                                      GL_RGBA,
                                                                      GLsizei(bufferWidth),
                                                                      GLsizei(bufferHeight),
                                                                      GLenum(GL_BGRA),
                                                                      GLenum(GL_UNSIGNED_BYTE),
                                                                      0,
                                                                      &inputTexture)
        if resultCode != kCVReturnSuccess {
            DDLogError("[VideoCamera] Could not create texture \(resultCode)")
            exit(1)
        }
        
        let inputTextureName = CVOpenGLESTextureGetName(inputTexture)
        
        glBindTexture(GLenum(GL_TEXTURE_2D), inputTextureName)
        glTexParameteri(GLenum(GL_TEXTURE_2D), GLenum(GL_TEXTURE_MIN_FILTER), GL_LINEAR)
        glTexParameteri(GLenum(GL_TEXTURE_2D), GLenum(GL_TEXTURE_MAG_FILTER), GL_LINEAR)
        glTexParameteri(GLenum(GL_TEXTURE_2D), GLenum(GL_TEXTURE_WRAP_S), GL_CLAMP_TO_EDGE)
        glTexParameteri(GLenum(GL_TEXTURE_2D), GLenum(GL_TEXTURE_WRAP_T), GL_CLAMP_TO_EDGE)

        VideoContext.sharedProcessingContext.setShaderProgram(program)
        
        outputFrameBuffer = VideoContext.sharedProcessingContext.frameBufferCache
            .fetchFrameBuffer(tag: "VideoCamera",
                              for: CGSize(width: rotatedBufferWidth,
                                          height: rotatedBufferHeight))
        outputFrameBuffer?.activate()
        
        glClearColor(GLclampf(backgroundColorRed),
                     GLclampf(backgroundColorGreen),
                     GLclampf(backgroundColorBlue),
                     GLclampf(backgroundColorAlpha))
        glClear(GLbitfield(GL_COLOR_BUFFER_BIT))
        
        glActiveTexture(GLenum(GL_TEXTURE0))
        glBindTexture(GLenum(GL_TEXTURE_2D), inputTextureName)
        glUniform1i(textureUniform, 0)
        
        glEnableVertexAttribArray(positionSlot)
        glVertexAttribPointer(positionSlot,
                              2,
                              GLenum(GL_FLOAT),
                              GLboolean(UInt8(GL_FALSE)),
                              GLsizei(0),
                              &squareVertices)
        
        glEnableVertexAttribArray(texturePositionSlot)
        glVertexAttribPointer(texturePositionSlot,
                              2,
                              GLenum(GL_FLOAT),
                              GLboolean(UInt8(GL_FALSE)),
                              GLsizei(0),
                              &textureVertices)
        
        glDrawArrays(GLenum(GL_TRIANGLE_STRIP), 0, 4)
        
        updateTargetsWithTexture(bufferWidth: rotatedBufferWidth,
                                 bufferHeight: rotatedBufferHeight,
                                 currentTime: currentTime)
    }

    private func textureCoordinates(for rotation: VideoRotation) -> [GLfloat] {
        switch rotation {
        case .noRotation:
            return [0, 0,
                    1, 0,
                    0, 1,
                    1, 1]
        case .rotateLeft:
            return [1, 0,
                    1, 1,
                    0, 0,
                    0, 1]
        case .rotateRight:
            return [0, 1,
                    0, 0,
                    1, 1,
                    1, 0]
        case .flipVertical:
            return [0, 1,
                    1, 1,
                    0, 0,
                    1, 0]
        case .flipHorizonal:
            return [1, 0,
                    0, 0,
                    1, 1,
                    0, 1]
        case .rotateRightFlipVertical:
            return [0, 0,
                    0, 1,
                    1, 0,
                    1, 1]
        case .rotateRightFlipHorizontal:
            return [1, 1,
                    1, 0,
                    0, 1,
                    0, 0]
        case .rotate180:
            return [1, 1,
                    0, 1,
                    1, 0,
                    0, 0]
        default:
            return [0, 1,
                    1, 1,
                    0, 0,
                    1, 0]
        }
    }

}

extension VideoCamera: AVCaptureVideoDataOutputSampleBufferDelegate {
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard session.isRunning, !capturePaused else { return }
        
        semaphore.wait()
        
        VideoContext.sharedProcessingContext.async { [weak self] in
            self?.processVideo(with: sampleBuffer)
            self?.semaphore.signal()
        }
    }
    
    func captureOutput(_ output: AVCaptureOutput, didDrop sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        // The frame may be dropped because it was late (kCMSampleBufferDroppedFrameReason_FrameWasLate), typically caused by the client’s processing taking too long.
        let reason = CMGetAttachment(sampleBuffer, key: kCMSampleBufferAttachmentKey_DroppedFrameReason, attachmentModeOut: nil)
        if let reason = reason {
            DDLogWarn("Capture output did drop sampleBuffer: \(String(describing: reason))")
        }
    }
    
}
