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
        let sepia = VideoSepiaFilter()
        sepia.duration = 5.0
        filterProcessor.addFilter(sepia)
        let sticker = VideoAnimatedStickerFilter()
        sticker.duration = 10.0
        sticker.imageName = "walk"
        sticker.imageCount = 4
        sticker.imageInterval = 1.0 / 24 * 4
        sticker.rotate = .pi / 4
        sticker.scale = .init(width: 0.5, height: 0.5)
        filterProcessor.addFilter(sticker)
        
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
    
    func fetchFilter(at index: Int) -> VideoFilter {
        return filterProcessor.fetchFilter(at: index)
    }
    
    func updateFilter(_ filter: VideoFilter, at index: Int) {
        filterProcessor.updateFilter(filter, at: index)
    }

}
