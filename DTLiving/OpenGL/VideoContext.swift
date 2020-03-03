//
//  VideoContext.swift
//  DTLiving
//
//  Created by Dan Jiang on 2020/3/3.
//  Copyright © 2020 Dan Thought Studio. All rights reserved.
//

import GLKit
import CocoaLumberjack

class VideoContext {
    
    static let sharedProcessingContext = VideoContext(tag: "video processing")
    
    static var sharedProcessingQueue: DispatchQueue {
        return sharedProcessingContext.contextQueue
    }
    
    private let tag: String
    private let context: EAGLContext
    private let contextQueue: DispatchQueue
    private var shaderProgram: ShaderProgram?
    
    init(tag: String) {
        self.tag = "[\(tag)]"
        guard let context = EAGLContext(api: .openGLES2) else {
            DDLogError("\(tag) Could not initialize OpenGL context")
            exit(1)
        }
        self.context = context
        self.contextQueue = DispatchQueue(label: "\(tag) context queue", attributes: [], target: nil)
        
        EAGLContext.setCurrent(context)
        glDisable(GLenum(GL_DEPTH_TEST))
    }
    
    var coreVideoTextureCache: CVOpenGLESTextureCache {
        var textureCache: CVOpenGLESTextureCache!
        let resultCode = CVOpenGLESTextureCacheCreate(kCFAllocatorDefault, nil, context, nil, &textureCache)
        if resultCode != kCVReturnSuccess {
            DDLogError("\(tag) Could not create texture cache \(resultCode)")
            exit(1)
        }
        return textureCache
    }
    
    func useAsCurrentContext() {
        if context !== EAGLContext.current() {
            if !EAGLContext.setCurrent(context) {
                DDLogError("\(tag) Could not set current OpenGL context with new context")
                exit(1)
            }
        }
    }
    
    func setShaderProgram(_ program: ShaderProgram) {
        useAsCurrentContext()
        if shaderProgram != program {
            shaderProgram = program
            shaderProgram?.use()
        }
    }
    
}
