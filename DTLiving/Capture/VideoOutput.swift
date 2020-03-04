//
//  VideoOutput.swift
//  DTLiving
//
//  Created by Dan Jiang on 2020/2/28.
//  Copyright © 2020 Dan Thought Studio. All rights reserved.
//

import Foundation

class VideoOutput: NSObject {
    
    var targets: [VideoInput] = []
    var targetTextureIndices: [Int] = []
    
    var outputFrameBuffer: FrameBuffer!
    
    func addTarget(_ target: VideoInput) {
        
    }
    
    func removeTarget(_ target: VideoInput) {
        
    }
    
}
