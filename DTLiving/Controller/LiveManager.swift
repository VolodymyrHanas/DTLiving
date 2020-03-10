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
    private let preview: VideoView
    
    var previewView: VideoView {
        return preview
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(config: MediaConfig) {
        self.config = config
        
        camera = VideoCamera(position: .back, presets: [.hd1920x1080])
        preview = VideoView(frame: .init(x: 0, y: 0, width: 100, height: 100))
        
        camera.addTarget(preview)
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

}
