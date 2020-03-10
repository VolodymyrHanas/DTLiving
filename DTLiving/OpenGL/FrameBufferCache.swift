//
//  FrameBufferCache.swift
//  DTLiving
//
//  Created by Dan Jiang on 2020/3/10.
//  Copyright © 2020 Dan Thought Studio. All rights reserved.
//

import UIKit

class FrameBufferCache {
    
    private var frameBufferCache: [String: FrameBuffer] = [:]
    private var frameBufferTypeCount: [String: Int] = [:]
    
    func fetchFrameBuffer(tag: String, for size: CGSize) -> FrameBuffer {
        var frameBufferFromCache: FrameBuffer!
        VideoContext.sharedProcessingContext.sync {
            let lookupHash = hash(for: size)
            let numberOfMatchingTextures = frameBufferTypeCount[lookupHash] ?? 0
            if numberOfMatchingTextures < 1 {
                frameBufferFromCache = FrameBuffer(tag: tag, size: size)
            } else {
                var currentTextureID = numberOfMatchingTextures - 1
                while frameBufferFromCache == nil && currentTextureID >= 0 {
                    let textureHash = "\(lookupHash)-\(currentTextureID)"
                    frameBufferFromCache = frameBufferCache[textureHash]
                    if frameBufferFromCache != nil {
                        frameBufferCache[textureHash] = nil
                    }
                    currentTextureID -= 1
                }
                currentTextureID += 1
                frameBufferTypeCount[lookupHash] = currentTextureID
                if frameBufferFromCache == nil {
                    frameBufferFromCache = FrameBuffer(tag: tag, size: size)
                }
            }
        }
        frameBufferFromCache.lock()
        return frameBufferFromCache
    }
    
    func returnFrameBuffer(_ frameBuffer: FrameBuffer) {
        frameBuffer.clearLock()
        
        VideoContext.sharedProcessingContext.sync {
            let frameBufferSize = frameBuffer.size
            let lookupHash = hash(for: frameBufferSize)
            let numberOfMatchingTextures = frameBufferTypeCount[lookupHash] ?? 0
            let textureHash = "\(lookupHash)-\(numberOfMatchingTextures)"
            frameBufferCache[textureHash] = frameBuffer
            frameBufferTypeCount[lookupHash] = numberOfMatchingTextures + 1
        }
    }
    
    private func hash(for size: CGSize) -> String {
        return String(format: "%.1fx%.1f", size.width, size.height)
    }
    
}
