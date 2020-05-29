//
//  VideoRecorder.swift
//  DTLiving
//
//  Created by Dan Jiang on 2020/5/29.
//  Copyright © 2020 Dan Thought Studio. All rights reserved.
//

import UIKit
import GLKit
import AVFoundation
import CocoaLumberjack

protocol VideoRecorderDelegate: class {
    func videoRecorderDidFinishPreparing(_ recorder: VideoRecorder)
    func videoRecorder(_ recorder: VideoRecorder, didFailWithError error: Error?)
    func videoRecorderDidFinishRecording(_ recorder: VideoRecorder)
}

class VideoRecorder: VideoInput {
    
    var backgroundColorRed: CGFloat = 0.0
    var backgroundColorGreen: CGFloat = 0.0
    var backgroundColorBlue: CGFloat = 0.0
    var backgroundColorAlpha: CGFloat = 1.0

    private let url: URL
    private let fileType: AVFileType
    private weak var delegate: VideoRecorderDelegate?
    private var delegateCallbackQueue: DispatchQueue

    private var recordContext: VideoContext
    private var inputFrameBuffer: FrameBuffer?
    private var inputRotation: VideoRotation = .noRotation {
        didSet {
            if inputRotation != oldValue {
                textureVertices = VideoContext.textureCoordinates(for: inputRotation)
            }
        }
    }
    
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

    private var recordFrameBuffer: GLuint = 0
    private var recordPixelBuffer: CVPixelBuffer!
    private var recordTexture: CVOpenGLESTexture!
    private var recordTextureName: GLuint = 0
    private var outputSize: CGSize = .zero
    
    private enum RecorderStatus: Int, CustomStringConvertible {
        case idle = 0
        case preparingToRecord
        case recording
        // waiting for inflight buffers to be appended
        case finishingRecordingPart1
        // calling finish writing on the asset writer
        case finishingRecordingPart2
        // terminal state
        case finished
        // terminal state
        case failed
        
        var description: String {
            switch self {
            case .idle:
                return "Idle"
            case .preparingToRecord:
                return "PreparingToRecord"
            case .recording:
                return "Recording"
            case .finishingRecordingPart1:
                return "FinishingRecordingPart1"
            case .finishingRecordingPart2:
                return "FinishingRecordingPart2"
            case .finished:
                return "Finished"
            case .failed:
                return "Failed"
            }
        }
    }  // internal state machine
    private var status: RecorderStatus = .idle
    
    private var videoTrackSourceFormatDescription: CMFormatDescription?
    private var videoTrackSettings: [String: Any] = [:]
    private var videoInput: AVAssetWriterInput!
    
    private var audioTrackSourceFormatDescription: CMFormatDescription?
    private var audioTrackSettings: [String: Any] = [:]
    private var audioInput: AVAssetWriterInput!

    private var assetWriter: AVAssetWriter?
    private var isSessionStarted: Bool = false

    deinit {
        recordContext.sync {
            destroyRecordFrameBuffer()
        }
    }

    init(url: URL, fileType: AVFileType, size: CGSize,
         delegate: VideoRecorderDelegate, callbackQueue queue: DispatchQueue) {
        self.url = url
        self.fileType = fileType
        outputSize = size
        self.delegate = delegate
        self.delegateCallbackQueue = queue

        recordContext = VideoContext(tag: "video recording",
                                     sharegroup: VideoContext.sharedProcessingContext.context.sharegroup)
        
        recordContext.sync {
            recordContext.useAsCurrentContext()
            
            createShaderProgram()
            createRecordFrameBuffer()
        }
    }

    var nextAvailableTextureIndex: Int {
        return 0
    }

    var enabled: Bool {
        return true
    }

    func setInputFrameBuffer(_ inputFrameBuffer: FrameBuffer?, at index: Int) {
        self.inputFrameBuffer = inputFrameBuffer
        inputFrameBuffer?.lock()
    }

    func setInputRotation(_ rotation: VideoRotation, at index: Int) {
        inputRotation = rotation
    }

    func setInputSize(_ size: CGSize, at index: Int) {}
    
    func newFrameReady(at time: CMTime, at index: Int) {
        guard let inputFrameBuffer = inputFrameBuffer else { return }
        
        recordContext.async { [weak self] in
            guard self?.status == .recording else {
                self?.inputFrameBuffer?.unlock()
                self?.inputFrameBuffer = nil
                return
            }
            guard let self = self else { return }
            
            self.recordContext.setShaderProgram(self.program)
            self.setRecordFrameBuffer()
            
            glClearColor(GLclampf(self.backgroundColorRed),
                         GLclampf(self.backgroundColorGreen),
                         GLclampf(self.backgroundColorBlue),
                         GLclampf(self.backgroundColorAlpha))
            glClear(GLbitfield(GL_COLOR_BUFFER_BIT))
            
            glActiveTexture(GLenum(GL_TEXTURE0))
            glBindTexture(GLenum(GL_TEXTURE_2D), inputFrameBuffer.textureName)
            glUniform1i(self.textureUniform, 0)
            
            glEnableVertexAttribArray(self.positionSlot)
            glVertexAttribPointer(self.positionSlot,
                                  2,
                                  GLenum(GL_FLOAT),
                                  GLboolean(UInt8(GL_FALSE)),
                                  GLsizei(0),
                                  &self.squareVertices)
            
            glEnableVertexAttribArray(self.texturePositionSlot)
            glVertexAttribPointer(self.texturePositionSlot,
                                  2,
                                  GLenum(GL_FLOAT),
                                  GLboolean(UInt8(GL_FALSE)),
                                  GLsizei(0),
                                  &self.textureVertices)
            
            glDrawArrays(GLenum(GL_TRIANGLE_STRIP), 0, 4)
            glFinish() // Blocks until all commands issued so far have completed.

            self.appendVideoPixelBuffer(self.recordPixelBuffer, pts: time)
            
            self.inputFrameBuffer?.unlock()
            self.inputFrameBuffer = nil
        }
    }
    
    func endProcessing() {}
    
    private func createShaderProgram() {
        recordContext.sync {
            let program = ShaderProgramObject(vertexShader: "effect_vertex", fragmentShader: "effect_fragment")
            positionSlot = program.attributeLocation("a_position")
            texturePositionSlot = program.attributeLocation("a_texcoord")
            textureUniform = program.uniformLocation("u_texture")
            self.program = program
        }
    }
    
    private func createRecordFrameBuffer() {
        recordContext.useAsCurrentContext()

        glGenFramebuffers(1, &recordFrameBuffer)
        glBindFramebuffer(GLenum(GL_FRAMEBUFFER), recordFrameBuffer)
                
        let attrs: NSDictionary = [kCVPixelBufferIOSurfacePropertiesKey:  NSDictionary()]
        var resultCode = CVPixelBufferCreate(kCFAllocatorDefault, Int(outputSize.width), Int(outputSize.height),
                            kCVPixelFormatType_32BGRA, attrs, &recordPixelBuffer)
        if resultCode != kCVReturnSuccess {
            DDLogError("[VideoRecorder] Could not create pixel buffer \(resultCode)")
            exit(1)
        }
        
        let textureCache = recordContext.textureCache
        resultCode = CVOpenGLESTextureCacheCreateTextureFromImage(kCFAllocatorDefault,
                                                                  textureCache,
                                                                  recordPixelBuffer,
                                                                  nil,
                                                                  GLenum(GL_TEXTURE_2D),
                                                                  GL_RGBA,
                                                                  GLsizei(outputSize.width),
                                                                  GLsizei(outputSize.height),
                                                                  GLenum(GL_BGRA),
                                                                  GLenum(GL_UNSIGNED_BYTE),
                                                                  0,
                                                                  &recordTexture)
        if resultCode != kCVReturnSuccess {
            DDLogError("[VideoRecorder] Could not create texture \(resultCode)")
            exit(1)
        }
        
        recordTextureName = CVOpenGLESTextureGetName(recordTexture)
            
        glBindTexture(GLenum(GL_TEXTURE_2D), recordTextureName)
        glTexParameteri(GLenum(GL_TEXTURE_2D), GLenum(GL_TEXTURE_MIN_FILTER), GL_LINEAR)
        glTexParameteri(GLenum(GL_TEXTURE_2D), GLenum(GL_TEXTURE_MAG_FILTER), GL_LINEAR)
        glTexParameteri(GLenum(GL_TEXTURE_2D), GLenum(GL_TEXTURE_WRAP_S), GL_CLAMP_TO_EDGE)
        glTexParameteri(GLenum(GL_TEXTURE_2D), GLenum(GL_TEXTURE_WRAP_T), GL_CLAMP_TO_EDGE)
        
        glFramebufferTexture2D(GLenum(GL_FRAMEBUFFER), GLenum(GL_COLOR_ATTACHMENT0),
                               GLenum(GL_TEXTURE_2D), recordTextureName, 0)
        
        if glCheckFramebufferStatus(GLenum(GL_FRAMEBUFFER)) != GL_FRAMEBUFFER_COMPLETE {
            DDLogError("[VideoRecorder] Could not generate frame buffer")
            exit(1)
        }
        
        glBindTexture(GLenum(GL_TEXTURE_2D), 0)
    }
    
    private func destroyRecordFrameBuffer() {
        recordContext.useAsCurrentContext()
        
        if recordFrameBuffer != 0 {
            glDeleteFramebuffers(1, &recordFrameBuffer)
            recordFrameBuffer = 0
        }
        
        recordPixelBuffer = nil
        recordTexture = nil
        
        if recordTextureName != 0 {
            glDeleteTextures(1, &recordTextureName)
            recordTextureName = 0
        }
    }
    
    private func setRecordFrameBuffer() {
        glBindFramebuffer(GLenum(GL_FRAMEBUFFER), recordFrameBuffer)
        glViewport(0, 0, GLsizei(outputSize.width), GLsizei(outputSize.height))
    }
    
    private func addVideoTrack(with formatDescription: CMFormatDescription, settings videoSettings: [String : Any]) {
        if status != .idle {
            fatalError("Cannot add tracks while not idle")
        }
        
        if videoTrackSourceFormatDescription != nil {
            fatalError("Cannot add more than one video track")
        }
        
        videoTrackSourceFormatDescription = formatDescription
        videoTrackSettings = videoSettings
    }
    
    private func addAudioTrack(with formatDescription: CMFormatDescription, settings audioSettings: [String : Any]) {
        if status != .idle {
            fatalError("Cannot add tracks while not idle")
        }
        
        if audioTrackSourceFormatDescription != nil {
            fatalError("Cannot add more than one audio track")
        }
        
        audioTrackSourceFormatDescription = formatDescription
        audioTrackSettings = audioSettings
    }
    
    func prepareToRecord() {
        if status != .idle {
            fatalError("Already prepared, cannot prepare again")
        }
        
        transitionToStatus(.preparingToRecord, error: nil)
        
        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let self = self else { return }
            
            var error: Error? = nil
            
            do {
                self.assetWriter = try AVAssetWriter(outputURL: self.url, fileType: self.fileType)
                
                // Create and add inputs
                self.setupAssetWriterVideoInput()
//                self.setupAssetWriterAudioInput()
                
                let success = self.assetWriter?.startWriting() ?? false
                if !success {
                    error = self.assetWriter?.error
                }
            } catch let err {
                error = err
            }
            
            if let error = error {
                self.transitionToStatus(.failed, error: error)
            } else {
                self.transitionToStatus(.recording, error: nil)
            }
        }
    }
    
    func finishRecording() {
        var shouldFinishRecording = false
        switch status {
        case .idle,
             .preparingToRecord,
             .finishingRecordingPart1,
             .finishingRecordingPart2,
             .finished:
            fatalError("Not recording")
        case .failed:
            // From the client's perspective the movie recorder can asynchronously transition to an error state as the result of an append.
            // Because of this we are lenient when finishRecording is called and we are in an error state.
            print("Recording has failed, nothing to do")
        case .recording:
            shouldFinishRecording = true
        }
        
        if shouldFinishRecording {
            transitionToStatus(.finishingRecordingPart1, error: nil)
        } else {
            return
        }

        recordContext.async { [weak self] in
            guard let self = self else { return }
            // We may have transitioned to an error state as we appended inflight buffers. In that case there is nothing to do now.
            if self.status != .finishingRecordingPart1 {
                return
            }
            
            // It is not safe to call -[AVAssetWriter finishWriting*] concurrently with -[AVAssetWriterInput appendSampleBuffer:]
            // We transition to MovieRecorderStatusFinishingRecordingPart2 while on _writingQueue, which guarantees that no more buffers will be appended.
            self.transitionToStatus(.finishingRecordingPart2, error: nil)
            self.assetWriter?.finishWriting { [weak self] in
                guard let self = self else { return }
                if let error = self.assetWriter?.error {
                    self.transitionToStatus(.failed, error: error)
                } else {
                    self.transitionToStatus(.finished, error: nil)
                }
            }
        }
    }
    
    private func appendVideoPixelBuffer(_ pixelBuffer: CVPixelBuffer, pts: CMTime) {
        var sampleBuffer: CMSampleBuffer?
        
        var timingInfo = CMSampleTimingInfo()
        timingInfo.duration = .invalid
        timingInfo.decodeTimeStamp = .invalid
        timingInfo.presentationTimeStamp = pts
        
        var formatDescription: CMFormatDescription!
        CMVideoFormatDescriptionCreateForImageBuffer(allocator: kCFAllocatorDefault,
                                                     imageBuffer: pixelBuffer,
                                                     formatDescriptionOut: &formatDescription)

        let resultCode = CMSampleBufferCreateForImageBuffer(allocator: kCFAllocatorDefault,
                                                            imageBuffer: pixelBuffer,
                                                            dataReady: true,
                                                            makeDataReadyCallback: nil,
                                                            refcon: nil,
                                                            formatDescription: formatDescription,
                                                            sampleTiming: &timingInfo,
                                                            sampleBufferOut: &sampleBuffer)
        
        if let sampleBuffer = sampleBuffer {
            self.appendSampleBuffer(sampleBuffer, ofMediaType: .video)
        } else {
            fatalError("sample buffer create failed (\(resultCode))")
        }
    }

    private func appendVideoSampleBuffer(_ sampleBuffer: CMSampleBuffer) {
        appendSampleBuffer(sampleBuffer, ofMediaType: .video)
    }
    
    private func appendAudioSampleBuffer(_ sampleBuffer: CMSampleBuffer) {
        appendSampleBuffer(sampleBuffer, ofMediaType: .audio)
    }
    
    private func setupAssetWriterVideoInput() {
        guard let assetWriter = assetWriter else {
                fatalError("Cannot setup asset writer`s video input")
        }
        
        var videoSettings = videoTrackSettings
        if videoSettings.isEmpty {
            print("No video settings provided, using default settings")

            var bitsPerPixel: Float
            let numPixels = outputSize.width * outputSize.height
            var bitsPerSecond: Int
            
            // Assume that lower-than-SD resolutions are intended for streaming, and use a lower bitrate
            if numPixels < 640 * 480 {
                bitsPerPixel = 4.05 // This bitrate approximately matches the quality produced by AVCaptureSessionPresetMedium or Low.
            } else {
                bitsPerPixel = 10.1 // This bitrate approximately matches the quality produced by AVCaptureSessionPresetHigh.
            }
            
            bitsPerSecond = Int(Float(numPixels) * bitsPerPixel)
            
            let compressionProperties: NSDictionary = [AVVideoAverageBitRateKey : bitsPerSecond,
                                                       AVVideoExpectedSourceFrameRateKey : 24,
                                                       AVVideoMaxKeyFrameIntervalKey : 24]
            
            videoSettings = [AVVideoCodecKey : AVVideoCodecH264,
                             AVVideoWidthKey : outputSize.width,
                             AVVideoHeightKey : outputSize.height,
                             AVVideoCompressionPropertiesKey : compressionProperties]
        } else {
            videoSettings[AVVideoWidthKey] = outputSize.width
            videoSettings[AVVideoHeightKey] = outputSize.height
        }
        
        if assetWriter.canApply(outputSettings: videoSettings, forMediaType: .video) {
            videoInput = AVAssetWriterInput(mediaType: .video, outputSettings: videoSettings)
            videoInput.expectsMediaDataInRealTime = true
            
            if assetWriter.canAdd(videoInput) {
                assetWriter.add(videoInput)
            } else {
                fatalError("Cannot add video input to asset writer")
            }
        } else {
            fatalError("Cannot apply video settings to asset writer")
        }
    }
    
    private func setupAssetWriterAudioInput() {
        guard let formatDescription = audioTrackSourceFormatDescription,
            let assetWriter = assetWriter else {
                fatalError("Cannot setup asset writer`s audio input")
        }

        var audioSettings = audioTrackSettings
        if audioSettings.isEmpty {
            print("No audio settings provided, using default settings")
            audioSettings = [AVFormatIDKey : kAudioFormatMPEG4AAC]
        }
        
        if assetWriter.canApply(outputSettings: audioSettings, forMediaType: .audio) {
            audioInput = AVAssetWriterInput(mediaType: .audio, outputSettings: audioSettings, sourceFormatHint: formatDescription)
            audioInput.expectsMediaDataInRealTime = true
            
            if assetWriter.canAdd(audioInput) {
                assetWriter.add(audioInput)
            } else {
                fatalError("Cannot add audio input to asset writer")
            }
        } else {
            fatalError("Cannot apply audio settings to asset writer")
        }
    }
    
    private func appendSampleBuffer(_ sampleBuffer: CMSampleBuffer, ofMediaType mediaType: AVMediaType) {
        if status.rawValue < RecorderStatus.recording.rawValue {
            fatalError("Not ready to record yet")
        }

        recordContext.async { [weak self] in
            guard let self = self else { return }
            // From the client's perspective the movie recorder can asynchronously transition to an error state as the result of an append.
            // Because of this we are lenient when samples are appended and we are no longer recording.
            // Instead of throwing an exception we just release the sample buffers and return.
            if self.status.rawValue > RecorderStatus.finishingRecordingPart1.rawValue {
                return
            }

            if !self.isSessionStarted {
                self.assetWriter?.startSession(atSourceTime: CMSampleBufferGetPresentationTimeStamp(sampleBuffer))
                self.isSessionStarted = true
            }
            
            let input = (mediaType == .video) ? self.videoInput : self.audioInput
            
            if let input = input {
                if input.isReadyForMoreMediaData {
                    let success = input.append(sampleBuffer)
                    if !success {
                        let error = self.assetWriter?.error
                        self.transitionToStatus(.failed, error: error)
                    }
                } else {
                    print("\(mediaType) input not ready for more media data, dropping buffer")
                }
            }
        }
    }

    private func transitionToStatus(_ status: RecorderStatus, error: Error?) {
        if let error = error {
            print("state transition from \(self.status.description) to \(status.description) with error: \(error)")
        }

        var shouldNotifyDelegate = false
        
        if status != self.status {
            // terminal states
            if status == .finished || status == .failed {
                shouldNotifyDelegate = true
                // make sure there are no more sample buffers in flight before we tear down the asset writer and inputs
                recordContext.async { [weak self] in
                    self?.teardownAssetWriterAndInputs()
                }
            } else if status == .recording {
                shouldNotifyDelegate = true
            }
            self.status = status
        }
        
        if shouldNotifyDelegate {
            delegateCallbackQueue.async { [weak self] in
                guard let self = self else { return }
                switch status {
                case .recording:
                    self.delegate?.videoRecorderDidFinishPreparing(self)
                case .finished:
                    self.delegate?.videoRecorderDidFinishRecording(self)
                case .failed:
                    self.delegate?.videoRecorder(self, didFailWithError: error)
                default:
                    fatalError("Unexpected recording status (\(status)) for delegate callback")
                }
            }
        }
    }
    
    private func teardownAssetWriterAndInputs() {
        videoInput = nil
        audioInput = nil
        assetWriter = nil
    }

}
