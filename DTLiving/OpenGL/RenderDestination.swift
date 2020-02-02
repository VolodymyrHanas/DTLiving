//
//  RenderDestination.swift
//  DTLiving
//
//  Created by Dan Jiang on 2020/2/1.
//  Copyright © 2020 Dan Thought Studio. All rights reserved.
//

import UIKit
import CocoaLumberjack

class RenderDestination {
    
    private let logTag: String

    private var frameBuffer: GLuint = 0
    private var renderBuffer: GLuint = 0
    
    init(logTag: String) {
        self.logTag = logTag
    }

    func createFrameBuffer() {
        glDisable(GLenum(GL_DEPTH_TEST))

        glGenFramebuffers(1, &frameBuffer)
        glBindFramebuffer(GLenum(GL_FRAMEBUFFER), frameBuffer)
    }
    
    func setViewport(width: Int, height: Int) {
        glViewport(0, 0, GLsizei(width), GLsizei(height))
        
        glClearColor(0.85, 0.85, 0.85, 1.0)
        glClear(GLbitfield(GL_COLOR_BUFFER_BIT))
    }

    func deleteFrameBuffer() {
        if frameBuffer != 0 {
            glDeleteFramebuffers(1, &frameBuffer)
            frameBuffer = 0
        }
    }
    
    func createRenderBuffer(context: EAGLContext, drawable: EAGLDrawable?) {
        glGenRenderbuffers(1, &renderBuffer)
        glBindRenderbuffer(GLenum(GL_RENDERBUFFER), renderBuffer)
        
        if !context.renderbufferStorage(Int(GL_RENDERBUFFER), from: drawable) {
            DDLogError("\(logTag) Could not bind a drawable object’s storage to a render buffer object")
            exit(1)
        }
    }
    
    func deleteRenderBuffer() {
        if renderBuffer != 0 {
            glDeleteRenderbuffers(1, &renderBuffer)
            renderBuffer = 0
        }
    }
    
    func attachFrameBufferToTexture(name: GLuint) {
        glFramebufferTexture2D(GLenum(GL_FRAMEBUFFER),
                               GLenum(GL_COLOR_ATTACHMENT0),
                               GLenum(GL_TEXTURE_2D),
                               name,
                               0)
    }
    
    func attachFrameBufferToRenderBuffer() {
        glFramebufferRenderbuffer(GLenum(GL_FRAMEBUFFER),
                                  GLenum(GL_COLOR_ATTACHMENT0),
                                  GLenum(GL_RENDERBUFFER),
                                  renderBuffer)
    }
    
    func checkFramebufferStatus() {
        if glCheckFramebufferStatus(GLenum(GL_FRAMEBUFFER)) != GL_FRAMEBUFFER_COMPLETE {
            DDLogError("\(logTag) Could not generate frame buffer")
            exit(1)
        }
    }
    
}
