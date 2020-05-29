//
//  LiveManager.swift
//  DTLiving
//
//  Created by Dan Jiang on 2020/2/28.
//  Copyright © 2020 Dan Thought Studio. All rights reserved.
//

import UIKit
import AVFoundation
import CocoaLumberjack

protocol LiveManagerDelegate: class {
    func liveManagerRecorderDidFinishPreparing(_ manager: LiveManager)
    func liveManagerRecorder(_ manager: LiveManager, didFailWithError error: Error?)
    func liveManagerRecorderDidFinishRecording(_ manager: LiveManager)
}

class LiveManager {
        
    weak var delegate: LiveManagerDelegate?

    var position: VideoCamera.Position

    private let camera: VideoCamera
    private let filterProcessor: VideoFilterProcessor
    private let preview: VideoView
    private var recorder: VideoRecorder?

    var previewView: VideoView {
        return preview
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(position: VideoCamera.Position) {
        self.position = position
        
        camera = VideoCamera(position: position, presets: [.hd1280x720])
        
        filterProcessor = VideoFilterProcessor()
        
        preview = VideoView()
                
        camera.addTarget(filterProcessor)
        filterProcessor.addTarget(preview)
    }
    
    func startCapture() {
        camera.startCapture()
    }
    
    func stopCaputre() {
        camera.stopCaputre()
    }
    
    func pauseCapture() {
        camera.pauseCapture()
    }
    
    func resumeCapture() {
        camera.resumeCapture()
    }
    
    func rotateCamera() {
        camera.rotateCamera()
    }
    
    func clearAllFilters() {
        filterProcessor.clearAllFilters()
    }
    
    var numberOfFilters: Int {
        return filterProcessor.numberOfFilters
    }
    
    func fetchFilter(at index: Int) -> VideoFilter {
        return filterProcessor.fetchFilter(at: index)
    }
    
    func addFilter(_ filter: VideoFilter) {
        filterProcessor.addFilter(filter)
    }
    
    func updateFilter(_ filter: VideoFilter, at index: Int) {
        filterProcessor.updateFilter(filter, at: index)
    }
    
    func startRecording() {
        if let videoFile = FileHelper.shared.getMediaFileURL(name: "video", ext: "mp4") {
            let recorder = VideoRecorder(url: videoFile, fileType: .mp4, size: .init(width: 720, height: 1280),
                                         delegate: self, callbackQueue: .main)
            filterProcessor.addTarget(recorder)
            recorder.prepareToRecord()
            self.recorder = recorder
        }
    }
    
    func stopRecording() {
        guard let recorder = recorder else { return }
        recorder.finishRecording()
        filterProcessor.removeTarget(recorder)
    }

}

extension LiveManager: VideoRecorderDelegate {
    
    func videoRecorderDidFinishPreparing(_ recorder: VideoRecorder) {
        delegate?.liveManagerRecorderDidFinishPreparing(self)
    }
    
    func videoRecorder(_ recorder: VideoRecorder, didFailWithError error: Error?) {
        delegate?.liveManagerRecorder(self, didFailWithError: error)
    }
    
    func videoRecorderDidFinishRecording(_ recorder: VideoRecorder) {
        delegate?.liveManagerRecorderDidFinishRecording(self)
    }

}
