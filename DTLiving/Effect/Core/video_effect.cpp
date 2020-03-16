//
//  video_effect.cpp
//  DTLiving
//
//  Created by Dan Jiang on 2020/3/12.
//  Copyright © 2020 Dan Thought Studio. All rights reserved.
//

#include "video_effect.h"

void VideoEffect::init() {
    program = new ShaderProgram(vertexShaderFile, fragmentShaderFile);
    
    positionSlot = program->attributeLocation("a_position");
    texturePositionSlot = program->attributeLocation("a_texcoord");
    textureUniform = program->uniformLocation("u_texture");
}

void VideoEffect::render(GLuint inputTexture, GLfloat *squareVertices, GLfloat *textureVertices) {
    glBindTexture(GL_TEXTURE_2D, inputTexture);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);

    program->useProgram();
        
    glClearColor(0.85, 0.85, 0.85, 1.0);
    glClear(GL_COLOR_BUFFER_BIT);
            
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, inputTexture);
    glUniform1i(textureUniform, 0);
    
    glEnableVertexAttribArray(positionSlot);
    glVertexAttribPointer(positionSlot,
                          2,
                          GL_FLOAT,
                          GL_FALSE,
                          0,
                          squareVertices);
    
    glEnableVertexAttribArray(texturePositionSlot);
    glVertexAttribPointer(texturePositionSlot,
                          2,
                          GL_FLOAT,
                          GL_FALSE,
                          0,
                          textureVertices);
    
    glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
}

void VideoEffect::setUniformFloat(const char *name, GLfloat value) {
    GLint location = program->uniformLocation(name);
    glUniform1f(location, value);
}
