//
//  shader_program.cpp
//  DTLiving
//
//  Created by Dan Jiang on 2020/3/12.
//  Copyright © 2020 Dan Thought Studio. All rights reserved.
//

#include "shader_program.h"

ShaderProgram::ShaderProgram(char *vertexShaderSource, char *fragmentShaderSource) {
    GLuint vertexShader = compileShader(vertexShaderSource, GL_VERTEX_SHADER);
    GLuint fragmentShader = compileShader(vertexShaderSource, GL_FRAGMENT_SHADER);
    
    GLuint program = glCreateProgram();
    glAttachShader(program, vertexShader);
    glAttachShader(program, fragmentShader);
    glLinkProgram(program);
    
    GLint linkStatus;
    glGetProgramiv(program, GL_LINK_STATUS, &linkStatus);
    if (linkStatus == GL_FALSE) {
        GLchar messages[256];
        glGetProgramInfoLog(program, sizeof(messages), 0, &messages[0]);
        std::cout << messages;
        exit(1);
    }
    
    if (vertexShader != 0) {
        glDeleteShader(vertexShader);
    }
    if (fragmentShader != 0) {
        glDeleteShader(fragmentShader);
    }
    
    this->program = program;
}

void ShaderProgram::useProgram() {
    glUseProgram(program);
}

void ShaderProgram::deleteProgram() {
    if (program != 0) {
        glDeleteProgram(program);
        program = 0;
    }
}

GLuint ShaderProgram::attributeLocation(char *name) {
    return glGetAttribLocation(program, name);
}

GLuint ShaderProgram::uniformLocation(char *name) {
    return glGetUniformLocation(program, name);
}

GLuint ShaderProgram::compileShader(const char *source, GLenum type) {
    GLuint shader = glCreateShader(type);
    glShaderSource(shader, 1, &source, 0);
    glCompileShader(shader);
    
    GLint compileStatus;
    glGetShaderiv(shader, GL_COMPILE_STATUS, &compileStatus);
    
    if (compileStatus == GL_FALSE) {
        GLchar messages[256];
        glGetShaderInfoLog(shader, sizeof(messages), 0, &messages[0]);
        std::cout << messages;
        exit(1);
    }
    
    return shader;
}
