//
//  VideoFilterProcessor.swift
//  DTLiving
//
//  Created by Dan Jiang on 2020/3/5.
//  Copyright © 2020 Dan Thought Studio. All rights reserved.
//

import CoreMedia

class VideoFilterProcessor: VideoOutput, VideoInput {
    
    private let processor = VideoEffectProcessorObject()
    
    var nextAvailableTextureIndex: Int {
        return 0
    }
    
    var enabled: Bool {
        return true
    }
    
    func setInputFrameBuffer(_ inputFrameBuffer: FrameBuffer?, at index: Int) {
        
    }
    
    func setInputSize(_ size: CGSize, at index: Int) {
    }
    
    func setInputRotation(_ rotation: VideoRotation, at index: Int) {
    }
    
    func newFrameReady(at time: CMTime, at index: Int) {
    }
    
    func endProcessing() {
    }
    
    func addFilter() {
        
    }

}
