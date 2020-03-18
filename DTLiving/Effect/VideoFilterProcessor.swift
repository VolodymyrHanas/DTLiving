//
//  VideoFilterProcessor.swift
//  DTLiving
//
//  Created by Dan Jiang on 2020/3/5.
//  Copyright © 2020 Dan Thought Studio. All rights reserved.
//

import CoreMedia

class VideoFilterProcessor: VideoOutput, VideoInput {
    
    private var inputFrameBuffer: FrameBuffer?
    private var inputRotation: VideoRotation = .noRotation
    private var inputSize: CGSize = .zero

    private let processor = VideoEffectProcessorObject()
    
    var nextAvailableTextureIndex: Int {
        return 0
    }
    
    var enabled: Bool {
        return true
    }
    
    func setInputFrameBuffer(_ inputFrameBuffer: FrameBuffer?, at index: Int) {
        self.inputFrameBuffer = inputFrameBuffer
        inputFrameBuffer?.lock()
    }
    
    func setInputRotation(_ rotation: VideoRotation, at index: Int) {
        inputRotation = rotation
    }

    func setInputSize(_ size: CGSize, at index: Int) {
        VideoContext.sharedProcessingContext.sync {
            var rotatedSize = size
            if inputRotation.needSwapWidthAndHeight {
                rotatedSize.width = size.height
                rotatedSize.height = size.width
            }
            if inputSize != rotatedSize {
                inputSize = rotatedSize
            }
        }
    }
    
    func newFrameReady(at time: CMTime, at index: Int) {
        outputFrameBuffer = VideoContext.sharedProcessingContext.frameBufferCache
            .fetchFrameBuffer(tag: "VideoFilterProcessor",
                              for: CGSize(width: inputSize.width,
                                          height: inputSize.height))
        outputFrameBuffer?.activate() // TODO: if neeed?

        guard let inputTexture = inputFrameBuffer?.textureName,
            let outputTexture = outputFrameBuffer?.textureName else { return }
        
        processor.processs(inputTexture, outputTexture: outputTexture)
        
        // TODO: tell targets
        
        inputFrameBuffer?.unlock()
    }
    
    func endProcessing() {
    }
    
    func addFilter() {
        
    }

}
