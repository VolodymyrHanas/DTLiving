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

class LiveManager {
    
    var config: MediaConfig
    
    private let camera: VideoCamera
    private let filterProcessor: VideoFilterProcessor
    private let preview: VideoView
    
    var previewView: VideoView {
        return preview
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(config: MediaConfig) {
        self.config = config
        
        camera = VideoCamera(position: .back, presets: [.hd1280x720])
        
        filterProcessor = VideoFilterProcessor()
        filterProcessor.addFilter(VideoGrayScaleFilter())
//        let filter = VideoCropFilter()
//        let height = 0.25
//        filter.cropRegion = .init(x: 0, y: (1 - height) / 2, width: 1, height: height)
//        filter.backgroundColorRed = 1;
//        filterProcessor.addFilter(filter)
        let filter = VideoBoxBlurFilter()        
        filterProcessor.addFilter(filter)
        
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
    
    func updateFilter(_ filter: VideoFilter) {
        filterProcessor.updateFilter(filter)
    }

}
