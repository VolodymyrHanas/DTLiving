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
    private var inputRotation: VideoRotation = .noRotation {
        didSet {
            for filter in filters where filter.isRotationAware {
                filter.rotation = inputRotation
                updateFilter(filter)
            }
        }
    }
    private var inputSize: CGSize = .zero {
        didSet {
            for filter in filters where filter.isSizeAware {
                filter.size = inputSize
                updateFilter(filter)
            }
        }
    }

    private let processor = VideoEffectProcessorObject()
    private var filters: [VideoFilter] = []

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
            if VideoRotationNeedSwapWidthAndHeight(inputRotation) {
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
        outputFrameBuffer?.activate()

        guard let inputTexture = inputFrameBuffer?.textureName,
            let outputTexture = outputFrameBuffer?.textureName else { return }
        
        processor.processs(inputTexture, outputTexture: outputTexture, size: inputSize)
                
        inputFrameBuffer?.unlock()
        
        updateTargetsWithTexture(currentTime: time)
    }
    
    func endProcessing() {
    }
    
    func addFilter(_ filter: VideoFilter) {
        if filter.isRotationAware {
            filter.rotation = inputRotation
        }
        if filter.isSizeAware {
            filter.size = inputSize
        }
        filters.append(filter)
        VideoContext.sharedProcessingContext.sync {
            processor.add(filter)
        }
    }
    
    func fetchFilter(at index: Int) -> VideoFilter {
        return filters[index]
    }
    
    func updateFilter(_ filter: VideoFilter, at index: Int) {
        filters[index] = filter
        updateFilter(filter)
    }
    
    private func updateFilter(_ filter: VideoFilter) {
        VideoContext.sharedProcessingContext.sync {
            processor.update(filter)
        }
    }
    
    private func updateTargetsWithTexture(currentTime: CMTime) {
        guard let outputFrameBuffer = outputFrameBuffer else { return }
        
        for (index, target) in targets.enumerated() {
            if target.enabled {
                let textureIndex = targetTextureIndices[index]
                target.setInputFrameBuffer(outputFrameBuffer, at: textureIndex)
                target.setInputSize(inputSize, at: textureIndex)
            }
        }
        
        outputFrameBuffer.unlock()
        self.outputFrameBuffer = nil
        
        for (index, target) in targets.enumerated() {
            if target.enabled {
                let textureIndex = targetTextureIndices[index]
                target.newFrameReady(at: currentTime, at: textureIndex)
            }
        }
    }

}
