//
//  EffectOpenGLFilter.swift
//  DTCamera
//
//  Created by Dan Jiang on 2019/9/27.
//  Copyright © 2019 Dan Thought Studio. All rights reserved.
//

import UIKit
import GLKit
import CoreMedia
import CocoaLumberjack

class EffectOpenGLFilter {

    var outputFormatDescription: CMFormatDescription?

    private let logTag = "Effect:"

    private var context: EAGLContext?

    // Input
    private var inputWidth: Int = 0
    private var inputHeight: Int = 0
    private var inputTexture: PixelBufferTexture?

    // Shader
    private var squareVertices: [GLfloat] = [ // before vertical flip
        -1, -1, // bottom left
        1, -1, // bottom right
        -1, 1, // top left
        1, 1, // top right
    ]
    private var textureVertices: [Float] = [
        0, 0, // bottom left
        1, 0, // bottom right
        0, 1, // top left
        1, 1, // top right
    ]
    private var program: ShaderProgram?
    private var positionSlot = GLuint()
    private var texturePositionSlot = GLuint()
    private var textureUniform = GLint()

    // Output
    private var outputWidth: Int = 0
    private var outputHeight: Int = 0
    private var outputTexture: PixelBufferTexture?
    private var renderDestination: RenderDestination?

    deinit {
        reset()
    }

    init() {
        guard let context = EAGLContext(api: .openGLES2) else {
            DDLogError("\(logTag) Could not initialize OpenGL context")
            exit(1)
        }
        self.context = context
    }
    
    func setup(with videoRatio: VideoRatio, cameraPosition: CameraPosition,
                 formatDescription: CMFormatDescription, retainedBufferCountHint: Int) {
        setupDimensions(videoRatio: videoRatio,
                        cameraPosition: cameraPosition,
                        formatDescription: formatDescription)
        
        let oldContext = EAGLContext.current()
        if context !== oldContext {
            if !EAGLContext.setCurrent(context) {
                DDLogError("\(logTag) Could not set current OpenGL context with new context")
                exit(1)
            }
        }
        
        setupInput()
        if program == nil {
            compileShaders()
        }
        setupOutputTexture(retainedBufferCountHint: retainedBufferCountHint)
        if renderDestination == nil {
            setupRenderDestination()
        }
        renderDestination?.setViewport(width: outputWidth, height: outputHeight)

        if oldContext !== context {
            if !EAGLContext.setCurrent(oldContext) {
                DDLogError("\(logTag) Could not set current OpenGL context with old context")
                exit(1)
            }
        }
    }

    func filter(pixelBuffer: CVPixelBuffer) -> CVPixelBuffer {
        let oldContext = EAGLContext.current()
        if context !== oldContext {
            if !EAGLContext.setCurrent(context) {
                DDLogError("\(logTag) Could not set current OpenGL context with new context")
                exit(1)
            }
        }

        program?.use()
        
        inputTexture?.createTexture(from: pixelBuffer)
        inputTexture?.bind(textureNo: GLenum(GL_TEXTURE1))
        glUniform1i(textureUniform, 1)
        
        guard let outputTexture = outputTexture else {
            DDLogError("\(logTag) Could not create output texture")
            exit(1)
        }
        let outputPixelBuffer = outputTexture.createPixelBuffer()
        outputTexture.createTexture(from: outputPixelBuffer)
        outputTexture.bind(textureNo: GLenum(GL_TEXTURE0))
        renderDestination?.attachFrameBufferToTexture(name: outputTexture.textureName)
        
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
        
        glFlush()
        
        inputTexture?.unbind()
        outputTexture.unbind()
        inputTexture?.deleteTexture()
        outputTexture.deleteTexture()

        if oldContext !== context {
            if !EAGLContext.setCurrent(oldContext) {
                DDLogError("\(logTag) Could not set current OpenGL context with old context")
                exit(1)
            }
        }
        
        return outputPixelBuffer
    }
    
    private func setupDimensions(videoRatio: VideoRatio,
                                 cameraPosition: CameraPosition,
                                 formatDescription: CMFormatDescription) {
        let dimensions = CMVideoFormatDescriptionGetDimensions(formatDescription)
        let sourceWidth = Float(dimensions.width)
        let sourceHeight = Float(dimensions.height)
        let targetWidth = sourceWidth
        let targetHeight = targetWidth * videoRatio.ratio
        let fromY = ((sourceHeight - targetHeight) / 2) / sourceHeight
        let toY = 1.0 - fromY
        textureVertices[1] = fromY
        textureVertices[3] = fromY
        textureVertices[5] = toY
        textureVertices[7] = toY
        let fromX: Float = 0.0
        let toX: Float = 1.0
        if cameraPosition == .front {
            textureVertices[0] = toX
            textureVertices[2] = fromX
            textureVertices[4] = toX
            textureVertices[6] = fromX
        } else {
            textureVertices[0] = fromX
            textureVertices[2] = toX
            textureVertices[4] = fromX
            textureVertices[6] = toX
        }
        inputWidth = Int(sourceWidth)
        inputHeight = Int(sourceHeight)
        outputWidth = Int(targetWidth)
        outputHeight = Int(targetHeight)
    }

    private func setupInput() {
        guard let context = context else { return }
        if let inputTexture = inputTexture {
            inputTexture.deleteTextureCache()
            self.inputTexture = nil
        }
        inputTexture = PixelBufferTexture(logTag: logTag, width: inputWidth, height: inputHeight)
        inputTexture?.createTextureCache(in: context)
    }
    
    private func compileShaders() {
        let program = ShaderProgram(vertexShaderName: "FilterVertex", fragmentShaderName: "FilterFragment")
        positionSlot = program.attributeLocation(for: "a_position")
        texturePositionSlot = program.attributeLocation(for: "a_texcoord")
        textureUniform = program.uniformLocation(for: "u_texture")
        self.program = program
    }
    
    private func setupOutputTexture(retainedBufferCountHint: Int) {
        guard let context = context else { return }
        if let outputTexture = outputTexture {
            outputTexture.deleteTextureCache()
            outputTexture.deleteBufferPool()
            self.outputTexture = nil
        }
        outputTexture = PixelBufferTexture(logTag: logTag, width: outputWidth, height: outputHeight,
                                           retainedBufferCountHint: retainedBufferCountHint)
        outputTexture?.createTextureCache(in: context)
        outputTexture?.createBufferPool()
        if let testPixelBuffer = outputTexture?.createPixelBuffer() {
            var outputFormatDescription: CMFormatDescription?
            CMVideoFormatDescriptionCreateForImageBuffer(allocator: kCFAllocatorDefault,
                                                         imageBuffer: testPixelBuffer,
                                                         formatDescriptionOut: &outputFormatDescription)
            self.outputFormatDescription = outputFormatDescription
        }
    }
    
    private func setupRenderDestination() {
        renderDestination = RenderDestination(logTag: logTag)
        renderDestination?.createFrameBuffer()
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
        renderDestination = nil
        program?.delete()
        program = nil
        inputTexture?.unbind()
        inputTexture?.deleteTexture()
        inputTexture?.deleteTextureCache()
        inputTexture = nil
        outputTexture?.unbind()
        outputTexture?.deleteTexture()
        outputTexture?.deleteTextureCache()
        outputTexture?.deleteBufferPool()
        outputTexture = nil
        outputFormatDescription = nil
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