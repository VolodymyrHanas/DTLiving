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
        filterProcessor.addFilter(VideoSepiaFilter())
        let filter = VideoTransformFilter()
        filter.backgroundColorRed = 1;
        var perspective: CATransform3D = CATransform3DIdentity
        perspective.m34 = 0.4
        perspective.m33 = 0.4
        perspective = CATransform3DScale(perspective, 0.75, 0.75, 0.75)
        perspective = CATransform3DRotate(perspective, 0.75, 0.0, 1.0, 0.0)
        filter.transform3D = perspective
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
