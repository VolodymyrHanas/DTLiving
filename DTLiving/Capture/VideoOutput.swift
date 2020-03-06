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
    
    var outputFrameBuffer: FrameBuffer?
    
    func addTarget(_ target: VideoInput) {
        let nextIndex = target.nextAvailableTextureIndex
        addTarget(target, at: nextIndex)
    }
    
    func addTarget(_ target: VideoInput, at index: Int) {
        let isContain = targets.contains { $0 === target }
        if isContain { return }
        
        VideoContext.sharedProcessingQueue.sync {
            target.setInputFrameBuffer(outputFrameBuffer, at: index)
            targets.append(target)
            targetTextureIndices.append(index)
        }
    }
    
    func removeTarget(_ target: VideoInput) {
        let firstIndex = targets.firstIndex { $0 === target }
        guard let indexOfTarget = firstIndex else { return }
        let index = targetTextureIndices[indexOfTarget]
        
        VideoContext.sharedProcessingQueue.sync {
            target.setInputSize(.zero, at: index)
            target.setInputRotation(.noRotation, at: index)
            targetTextureIndices.remove(at: indexOfTarget)
            targets.remove(at: indexOfTarget)
            target.endProcessing()
        }
    }
    
}
