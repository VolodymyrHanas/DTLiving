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
        sepia.duration = 15.0
        filterProcessor.addFilter(sepia)
        let text = VideoTextFilter()
        let attributedText = NSAttributedString(string: "大家好啊！大家好啊！大家好啊！大家好啊！大家好啊！大家好啊！大家好啊！",
                                                attributes: [.font: UIFont.boldSystemFont(ofSize: 48),
                                                             .foregroundColor: UIColor.green])
        text.setText(attributedText, size: .init(width: 720, height: 1280))        
        text.rotate = .pi / 4
        text.scale = .init(width: 2.0, height: 2.0)
        text.translate = .init(width: 0, height: -200)
        filterProcessor.addFilter(text)
        
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
