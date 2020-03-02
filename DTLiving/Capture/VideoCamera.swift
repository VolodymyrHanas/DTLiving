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
    
    private var config: MediaConfig

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
    private var videoConnection: AVCaptureConnection?
    private let videoProcessQueue = DispatchQueue(label: "camera video process queue", attributes: [], target: nil)
    private let semaphore = DispatchSemaphore(value: 1)
    private var capturePaused = false
    
    private var program: ShaderProgram?
    private var positionSlot = GLuint()
    private var texturePositionSlot = GLuint()
    private var textureUniform = GLint()

    init(config: MediaConfig) {
        self.config = config
     
        super.init()
        
        authorizeCamera()
        createShaderProgram()
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
        let program = ShaderProgram(vertexShaderName: "DirectPassVertex", fragmentShaderName: "DirectPassFragment")
        positionSlot = program.attributeLocation(for: "a_position")
        texturePositionSlot = program.attributeLocation(for: "a_texcoord")
        textureUniform = program.uniformLocation(for: "u_texture")
        self.program = program
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
        configVideoOrientation()
        
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
        if config.cameraPosition == .back {
            if let backCameraDevice = backCameraDevice {
                defaultVideoDevice = backCameraDevice
            } else {
                defaultVideoDevice = frontCameraDevice
                config.cameraPosition = .front
            }
        } else {
            if let frontCameraDevice = frontCameraDevice {
                defaultVideoDevice = frontCameraDevice
            } else {
                defaultVideoDevice = backCameraDevice
                config.cameraPosition = .back
            }
        }
        return defaultVideoDevice
    }

    private func configSessionPreset(for videoDevice: AVCaptureDevice) {
        var presets: [AVCaptureSession.Preset] = []
        presets.append(.hd1920x1080)
        presets.append(.hd1280x720)
        presets.append(.medium)
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
        videoConnection = videoDataOutput.connection(with: .video)
    }
    
    private func configVideoFrameRate(for videoDevice: AVCaptureDevice) {
        let desiredFrameRate = config.videoFrameRate
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
    
    private func configVideoOrientation() {
        videoConnection?.videoOrientation = .portrait
    }
    
    private func processVideo(with sampleBuffer: CMSampleBuffer) {
        // TODO: FrameBuffer, draw texture
    }

}

extension VideoCamera: AVCaptureVideoDataOutputSampleBufferDelegate {
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard session.isRunning, !capturePaused else { return }
        
        semaphore.wait()
        
        // TODO: Same Video Processing Queue in Context
        videoProcessQueue.async { [weak self] in
            self?.processVideo(with: sampleBuffer)
            self?.semaphore.signal()
        }
    }
    
    func captureOutput(_ output: AVCaptureOutput, didDrop sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        // The frame may be dropped because it was late (kCMSampleBufferDroppedFrameReason_FrameWasLate), typically caused by the client’s processing taking too long.
        let reason = CMGetAttachment(sampleBuffer, key: kCMSampleBufferAttachmentKey_DroppedFrameReason, attachmentModeOut: nil)
        DDLogWarn("Capture output did drop sampleBuffer: \(String(describing: reason))")
    }
    
}
