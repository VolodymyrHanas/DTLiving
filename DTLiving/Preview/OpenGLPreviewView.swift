//
//  OpenGLPreviewView.swift
//  DTLiving
//
//  Created by Dan Jiang on 2020/2/1.
//  Copyright © 2020 Dan Thought Studio. All rights reserved.
//

import UIKit
import GLKit
import CocoaLumberjack

class OpenGLPreviewView: UIView {
    
    private let logTag = "Preview:"
    
    private var context: EAGLContext?

    // Input
    private var inputWidth: Int = 0
    private var inputHeight: Int = 0
    private var inputTexture: PixelBufferTexture?

    // Shader
    private var squareVertices: [GLfloat] = [
        -1, -1, // bottom left
        1, -1, // bottom right
        -1, 1, // top left
        1, 1, // top right
    ]
    private var textureVertices: [Float] = [ // vertical flip
        0, 1, // top left
        1, 1, // top right
        0, 0, // bottom left
        1, 0, // bottom right
    ]
    private var program: ShaderProgram?
    private var positionSlot = GLuint()
    private var texturePositionSlot = GLuint()
    private var textureUniform = GLint()

    // Output
    private var outputWidth: Int = 0
    private var outputHeight: Int = 0
    private var renderDestination: RenderDestination?

    override class var layerClass: AnyClass {
        return CAEAGLLayer.self
    }

    private var eaglLayer: CAEAGLLayer? {
        return layer as? CAEAGLLayer
    }
    
    deinit {
        reset()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        guard let eaglLayer = eaglLayer else { return }
        eaglLayer.isOpaque = true
        eaglLayer.drawableProperties = [kEAGLDrawablePropertyRetainedBacking: false,
                                        kEAGLDrawablePropertyColorFormat: kEAGLColorFormatRGBA8]

        guard let context = EAGLContext(api: .openGLES2) else {
            DDLogError("\(logTag) Could not initialize OpenGL context")
            exit(1)
        }
        self.context = context
    }
    
    func display(pixelBuffer: CVPixelBuffer) {
        let oldContext = EAGLContext.current()
        if context != oldContext {
            if !EAGLContext.setCurrent(context) {
                DDLogError("\(logTag) Could not set current OpenGL context with new context")
                exit(1)
            }
        }
        
        inputWidth = CVPixelBufferGetWidth(pixelBuffer)
        inputHeight = CVPixelBufferGetHeight(pixelBuffer)

        if inputTexture == nil {
            setupInput()
        }
        if renderDestination == nil {
            compileShaders()
            setupOutput()
        }
                
        program?.use()
        
        inputTexture?.createTexture(from: pixelBuffer)
        inputTexture?.bind(textureNo: GLenum(GL_TEXTURE0))
        glUniform1i(textureUniform, 0)
        
        glEnableVertexAttribArray(positionSlot)
        glVertexAttribPointer(positionSlot,
                              2,
                              GLenum(GL_FLOAT),
                              GLboolean(UInt8(GL_FALSE)),
                              GLsizei(0),
                              &squareVertices)
        
        glEnableVertexAttribArray(texturePositionSlot)
        glVertexAttribPointer(texturePositionSlot,
                              2,
                              GLenum(GL_FLOAT),
                              GLboolean(UInt8(GL_FALSE)),
                              GLsizei(0),
                              &textureVertices)
        
        glDrawArrays(GLenum(GL_TRIANGLE_STRIP), 0, 4)

        context?.presentRenderbuffer(Int(GL_RENDERBUFFER))
        
        inputTexture?.unbind()
        inputTexture?.deleteTexture()
        
        if oldContext != context {
            if !EAGLContext.setCurrent(oldContext) {
                DDLogError("\(logTag) Could not set current OpenGL context with old context")
                exit(1)
            }
        }
    }
    
    func resetupInputAndOutputDimensions() {
        inputTexture = nil
        setupOutputDimensions()
    }
    
    private func setupInput() {
        guard let context = context else { return }
        inputTexture = PixelBufferTexture(logTag: logTag, width: inputWidth, height: inputHeight)
        inputTexture?.createTextureCache(in: context)
    }
    
    private func compileShaders() {
        let program = ShaderProgram(vertexShaderName: "DirectPassVertex", fragmentShaderName: "DirectPassFragment")
        positionSlot = program.attributeLocation(for: "a_position")
        texturePositionSlot = program.attributeLocation(for: "a_texcoord")
        textureUniform = program.uniformLocation(for: "u_texture")
        self.program = program
    }
    
    private func setupOutput() {
        guard let context = context, let eaglLayer = eaglLayer else { return }
        let renderDestination = RenderDestination(logTag: logTag)
        self.renderDestination = renderDestination
        renderDestination.createFrameBuffer()
        renderDestination.createRenderBuffer(context: context, drawable: eaglLayer)
        setupOutputDimensions()
        renderDestination.attachFrameBufferToRenderBuffer()
        renderDestination.checkFramebufferStatus()
    }
    
    private func setupOutputDimensions() {
        var width = GLint()
        var height = GLint()
        glGetRenderbufferParameteriv(GLenum(GL_RENDERBUFFER), GLenum(GL_RENDERBUFFER_WIDTH), &width)
        glGetRenderbufferParameteriv(GLenum(GL_RENDERBUFFER), GLenum(GL_RENDERBUFFER_HEIGHT), &height)
        outputWidth = Int(width)
        outputHeight = Int(height)
        renderDestination?.setViewport(width: outputWidth, height: outputHeight)
    }
    
    private func reset() {
        let oldContext = EAGLContext.current()
        if context != oldContext {
            if !EAGLContext.setCurrent(context) {
                DDLogError("\(logTag) Could not set current OpenGL context with new context")
                exit(1)
            }
        }
        renderDestination?.deleteFrameBuffer()
        renderDestination?.deleteRenderBuffer()
        renderDestination = nil
        program?.delete()
        program = nil
        inputTexture?.unbind()
        inputTexture?.deleteTexture()
        inputTexture?.deleteTextureCache()
        inputTexture = nil
        if oldContext != context {
            if !EAGLContext.setCurrent(oldContext) {
                DDLogError("\(logTag) Could not set current OpenGL context with old context")
                exit(1)
            }
        }
        EAGLContext.setCurrent(nil)
        context = nil
    }
    
}
