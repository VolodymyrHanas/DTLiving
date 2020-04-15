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
        
    static let queueKey = DispatchSpecificKey<Int>()

    let context: EAGLContext // TODO: EAGLContext 共享一个 EAGLSharegroup when send to video encoder

    private let tag: String
    private let contextQueue: DispatchQueue
    private lazy var queueContext = unsafeBitCast(self, to: Int.self)
    private var shaderProgram: ShaderProgramObject?
    private var _textureCache: CVOpenGLESTextureCache?
    private var _frameBufferCache: FrameBufferCache?
    
    init(tag: String) {
        self.tag = "[\(tag)]"
        guard let context = EAGLContext(api: .openGLES2) else {
            DDLogError("\(tag) Could not initialize OpenGL context")
            exit(1)
        }
        self.context = context
        contextQueue = DispatchQueue(label: "\(tag) context queue", attributes: [], target: nil)
        contextQueue.setSpecific(key: VideoContext.queueKey, value: queueContext)
        
        EAGLContext.setCurrent(context)
        glDisable(GLenum(GL_DEPTH_TEST))
    }
    
    func sync(closure: () -> Void) {
        if DispatchQueue.getSpecific(key: VideoContext.queueKey) != queueContext {
            contextQueue.sync(execute: closure)
        } else {
            closure()
        }
    }
    
    func async(closure: @escaping () -> Void) {
        if DispatchQueue.getSpecific(key: VideoContext.queueKey) != queueContext {
            contextQueue.async(execute: closure)
        } else {
            closure()
        }
    }
    
    var textureCache: CVOpenGLESTextureCache {
        if let textureCache = _textureCache {
            return textureCache
        } else {
            var textureCache: CVOpenGLESTextureCache!
            let resultCode = CVOpenGLESTextureCacheCreate(kCFAllocatorDefault, nil, context, nil, &textureCache)
            if resultCode != kCVReturnSuccess {
                DDLogError("\(tag) Could not create texture cache \(resultCode)")
                exit(1)
            }
            self._textureCache = textureCache
            return textureCache
        }
    }
    
    var frameBufferCache: FrameBufferCache {
        if let frameBufferCache = _frameBufferCache {
            return frameBufferCache
        } else {
            let frameBufferCache = FrameBufferCache()
            _frameBufferCache = frameBufferCache
            return frameBufferCache
        }
    }
    
    func useAsCurrentContext() {
        if context !== EAGLContext.current() {
            if !EAGLContext.setCurrent(context) {
                DDLogError("\(tag) Could not set current OpenGL context with new context")
                exit(1)
            }
        }
    }
    
    func setShaderProgram(_ program: ShaderProgramObject?) {
        useAsCurrentContext()
        if shaderProgram !== program {
            shaderProgram = program
            shaderProgram?.useProgram()
        }
    }
    
    func presentBufferForDisplay() {
        context.presentRenderbuffer(Int(GL_RENDERBUFFER))
    }
    
}
