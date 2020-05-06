//
//  shader_program.cpp
//  DTLiving
//
//  Created by Dan Jiang on 2020/3/12.
//  Copyright © 2020 Dan Thought Studio. All rights reserved.
//

#include "shader_program.h"

#include <iostream>
#include <fstream>

namespace dtliving {
namespace effect {

ShaderProgram::ShaderProgram() {
}

ShaderProgram::~ShaderProgram() {
}

void ShaderProgram::CompileFile(const char *vertex_shader_file, const char *fragment_shader_file) {
    std::ifstream vertex_shader_handle(vertex_shader_file);
    std::string vertex_shader_source;
    while (vertex_shader_handle) {
        std::string line;
        std::getline(vertex_shader_handle, line);
        vertex_shader_source += line;
    }
    vertex_shader_handle.close();
    
    std::ifstream fragment_shader_handle(fragment_shader_file);
    std::string fragment_shader_source;
    while (fragment_shader_handle) {
        std::string line;
        std::getline(fragment_shader_handle, line);
        fragment_shader_source += line;
    }
    fragment_shader_handle.close();

    CompileSource(vertex_shader_source.c_str(), fragment_shader_source.c_str());
}

void ShaderProgram::CompileSource(const char *vertex_shader_source, const char *fragment_shader_source) {
    GLuint vertex_shader = CompileShader(vertex_shader_source, GL_VERTEX_SHADER);
    GLuint fragment_shader = CompileShader(fragment_shader_source, GL_FRAGMENT_SHADER);
    
    GLuint program = glCreateProgram();
    glAttachShader(program, vertex_shader);
    glAttachShader(program, fragment_shader);
    glLinkProgram(program);
    
    GLint link_status;
    glGetProgramiv(program, GL_LINK_STATUS, &link_status);
    if (link_status == GL_FALSE) {
        GLchar messages[256];
        glGetProgramInfoLog(program, sizeof(messages), 0, &messages[0]);
        std::cout << messages;
        exit(1);
    }
    
    if (vertex_shader != 0) {
        glDeleteShader(vertex_shader);
    }
    if (fragment_shader != 0) {
        glDeleteShader(fragment_shader);
    }
    
    this->program_ = program;
}

void ShaderProgram::Use() {
    glUseProgram(program_);
}

void ShaderProgram::Delete() {
    if (program_ != 0) {
        glDeleteProgram(program_);
        program_ = 0;
    }
}

GLuint ShaderProgram::AttributeLocation(const char *name) {
    return glGetAttribLocation(program_, name);
}

GLint ShaderProgram::UniformLocation(const char *name) {
    return glGetUniformLocation(program_, name);
}

GLuint ShaderProgram::CompileShader(const char *source, GLenum type) {
    GLuint shader = glCreateShader(type);
    glShaderSource(shader, 1, &source, 0);
    glCompileShader(shader);
    
    GLint compile_status;
    glGetShaderiv(shader, GL_COMPILE_STATUS, &compile_status);
    
    if (compile_status == GL_FALSE) {
        GLchar messages[256];
        glGetShaderInfoLog(shader, sizeof(messages), 0, &messages[0]);
        std::cout << messages;
        exit(1);
    }
    
    return shader;
}

}
}
