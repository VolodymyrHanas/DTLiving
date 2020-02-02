//
//  CameraPipeline.swift
//  DTLiving
//
//  Created by Dan Jiang on 2020/1/31.
//  Copyright © 2020 Dan Thought Studio. All rights reserved.
//

import UIKit
import AVFoundation
import CocoaLumberjack

protocol CameraPipelineDelegate: class {
    func cameraPipelineConfigSuccess(_ pipeline: CameraPipeline)
    func cameraPipeline(_ pipeline: CameraPipeline, display pixelBuffer: CVPixelBuffer)
}

class CameraPipeline: NSObject {
    
    weak var delegate: CameraPipelineDelegate?
    
    var config: MediaConfig
    
    private enum SessionSetupResult {
        case success
        case notAuthorized
        case configurationFailed
    }

    // Pipeline
    private var setupResult: SessionSetupResult = .success
    private let sessionQueue = DispatchQueue(label: "camera session queue", attributes: [], target: nil)
    private let session = AVCaptureSession()
    private var videoDeviceInput: AVCaptureDeviceInput?
    private let videoDataOutputQueue = DispatchQueue(label: "camera video data output queue", attributes: [], target: nil)
    private let videoDataOutput = AVCaptureVideoDataOutput()
    private var videoConnection: AVCaptureConnection?
    private let videoProcessQueue = DispatchQueue(label: "camera video process queue", attributes: [], target: nil)
    private let semaphore = DispatchSemaphore(value: 1)

    // Effect
    private var effectFilter: EffectOpenGLFilter!
    private let retainedBufferCountHint = 6
    private var videoFormatDescription: CMFormatDescription?

    // Miscellaneous
    private let isRenderingEnabledQueue = DispatchQueue(label: "camera isRendering enabled queue", attributes: [.concurrent], target: nil)
    private var _isRenderingEnabled = false
    var isRenderingEnabled: Bool { // if allow to use GPU
        get {
            isRenderingEnabledQueue.sync {
                return _isRenderingEnabled
            }
        }
        set {
            isRenderingEnabledQueue.async(flags: .barrier) { [weak self] in
                self?._isRenderingEnabled = newValue
            }
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(config: MediaConfig) {
        self.config = config
    }
    
    func configure() {
        effectFilter = EffectOpenGLFilter()
        
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
    
    func reconfigure() {
        setEffectFilterNeedSetup()
        sessionQueue.async { [weak self] in
            self?.configureSession()
        }
    }
    
    func setEffectFilterNeedSetup() {
        videoFormatDescription = nil
    }

    func startSessionRunning() {
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
    
    func stopSessionRunning() {
        sessionQueue.async { [weak self] in
            guard let self = self else { return }
            if self.setupResult == .success {
                self.session.stopRunning()
            }
        }
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
        
        delegate?.cameraPipelineConfigSuccess(self)
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
        if videoFormatDescription == nil {
            if let formatDescription = CMSampleBufferGetFormatDescription(sampleBuffer) {
                effectFilter.setup(with: config.videoRatio, cameraPosition: config.cameraPosition,
                                   formatDescription: formatDescription, retainedBufferCountHint: retainedBufferCountHint)
                if let outputFormatDescription = effectFilter.outputFormatDescription {
                    videoFormatDescription = outputFormatDescription
                } else {
                    videoFormatDescription = formatDescription
                }
            }
            } else if let inputPixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) {
                let outputPixelBuffer = effectFilter.filter(pixelBuffer: inputPixelBuffer)
                DispatchQueue.main.sync { [weak self] in
                    guard let self = self else { return }
                    self.delegate?.cameraPipeline(self, display: outputPixelBuffer)
                }
            }
    }

}

extension CameraPipeline: AVCaptureVideoDataOutputSampleBufferDelegate {
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard isRenderingEnabled else { return }
        
        semaphore.wait()
        
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
