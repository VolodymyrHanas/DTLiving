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
        
    var position: VideoCamera.Position

    private let camera: VideoCamera
    private let filterProcessor: VideoFilterProcessor
    private let preview: VideoView
    
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

}
