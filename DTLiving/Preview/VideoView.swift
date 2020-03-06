//
//  VideoView.swift
//  DTLiving
//
//  Created by Dan Jiang on 2020/3/5.
//  Copyright © 2020 Dan Thought Studio. All rights reserved.
//

import UIKit
import GLKit
import CoreMedia
import CocoaLumberjack

class VideoView: UIView, VideoInput {
    
    private var inputRotation: VideoRotation = .noRotation

    private var program: ShaderProgram?
    private var positionSlot = GLuint()
    private var texturePositionSlot = GLuint()
    private var textureUniform = GLint()

    override class var layerClass: AnyClass {
        return CAEAGLLayer.self
    }

    private var eaglLayer: CAEAGLLayer? {
        return layer as? CAEAGLLayer
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentScaleFactor = UIScreen.main.scale
        
        guard let eaglLayer = eaglLayer else { return }
        eaglLayer.isOpaque = true
        eaglLayer.drawableProperties = [kEAGLDrawablePropertyRetainedBacking: false,
                                        kEAGLDrawablePropertyColorFormat: kEAGLColorFormatRGBA8]

        VideoContext.sharedProcessingQueue.sync {
            VideoContext.sharedProcessingContext.useAsCurrentContext()
            
            createShaderProgram()
            
            VideoContext.sharedProcessingContext.setShaderProgram(program)
            
            // TODO: Fill Mode
        }
    }
    
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
    
    private func createShaderProgram() {
        VideoContext.sharedProcessingQueue.sync { [weak self] in
            let program = ShaderProgram(vertexShaderName: "DirectPassVertex", fragmentShaderName: "DirectPassFragment")
            positionSlot = program.attributeLocation(for: "a_position")
            texturePositionSlot = program.attributeLocation(for: "a_texcoord")
            textureUniform = program.uniformLocation(for: "u_texture")
            self?.program = program
        }
    }
    
    private func createDisplayFrameBuffer() {
        // TODO: Frame Buffer
    }

}
