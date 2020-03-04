//
//  FrameBuffer.swift
//  DTLiving
//
//  Created by Dan Jiang on 2020/3/2.
//  Copyright © 2020 Dan Thought Studio. All rights reserved.
//

import GLKit
import CocoaLumberjack

class FrameBuffer {
    
    private let tag: String
    private let size: CGSize
    
    private var textureName: GLuint = 0
    private var frameBuffer: GLuint = 0
    private var pixelBuffer: CVPixelBuffer!
    private var texture: CVOpenGLESTexture!
    
    init(tag: String, size: CGSize) {
        self.tag = "[\(tag)]"
        self.size = size
        
        generateFrameBuffer()
    }
    
    func generateFrameBuffer() {
        VideoContext.sharedProcessingQueue.sync {
            VideoContext.sharedProcessingContext.useAsCurrentContext()
            
            glGenFramebuffers(1, &frameBuffer)
            glBindFramebuffer(GLenum(GL_FRAMEBUFFER), frameBuffer)
                        
            let attrs: NSDictionary = [kCVPixelBufferIOSurfacePropertiesKey:  NSDictionary()]
            var resultCode = CVPixelBufferCreate(kCFAllocatorDefault, Int(size.width), Int(size.height),
                                kCVPixelFormatType_32BGRA, attrs, &pixelBuffer)
            if resultCode != kCVReturnSuccess {
                DDLogError("\(tag) Could not create pixel buffer \(resultCode)")
                exit(1)
            }
            
            let textureCache = VideoContext.sharedProcessingContext.coreVideoTextureCache
            resultCode = CVOpenGLESTextureCacheCreateTextureFromImage(kCFAllocatorDefault,
                                                                      textureCache,
                                                                      pixelBuffer,
                                                                      nil,
                                                                      GLenum(GL_TEXTURE_2D),
                                                                      GL_RGBA,
                                                                      GLsizei(size.width),
                                                                      GLsizei(size.height),
                                                                      GLenum(GL_BGRA),
                                                                      GLenum(GL_UNSIGNED_BYTE),
                                                                      0,
                                                                      &texture)
            if resultCode != kCVReturnSuccess {
                DDLogError("\(tag) Could not create texture \(resultCode)")
                exit(1)
            }
            
            textureName = CVOpenGLESTextureGetName(texture)
                
            glBindTexture(GLenum(GL_TEXTURE_2D), textureName)
            glTexParameteri(GLenum(GL_TEXTURE_2D), GLenum(GL_TEXTURE_MIN_FILTER), GL_LINEAR)
            glTexParameteri(GLenum(GL_TEXTURE_2D), GLenum(GL_TEXTURE_MAG_FILTER), GL_LINEAR)
            glTexParameteri(GLenum(GL_TEXTURE_2D), GLenum(GL_TEXTURE_WRAP_S), GL_CLAMP_TO_EDGE)
            glTexParameteri(GLenum(GL_TEXTURE_2D), GLenum(GL_TEXTURE_WRAP_T), GL_CLAMP_TO_EDGE)
            
            glFramebufferTexture2D(GLenum(GL_FRAMEBUFFER), GLenum(GL_COLOR_ATTACHMENT0),
                                   GLenum(GL_TEXTURE_2D), textureName, 0)
            
            if glCheckFramebufferStatus(GLenum(GL_FRAMEBUFFER)) != GL_FRAMEBUFFER_COMPLETE {
                DDLogError("\(tag) Could not generate frame buffer")
                exit(1)
            }
            
            glBindTexture(GLenum(GL_TEXTURE_2D), 0)
        }
    }
    
    func activate() {
        glBindFramebuffer(GLenum(GL_FRAMEBUFFER), frameBuffer)
        glViewport(0, 0, GLsizei(size.width), GLsizei(size.height))
    }
    
}
