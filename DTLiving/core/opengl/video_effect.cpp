//
//  video_effect.cpp
//  DTLiving
//
//  Created by Dan Jiang on 2020/3/12.
//  Copyright © 2020 Dan Thought Studio. All rights reserved.
//

#include "video_effect.h"

namespace dtliving {
namespace opengl {

VideoEffect::VideoEffect(const char *name, const char *vertex_shader_file, const char *fragment_shader_file)
: name_(name)
, vertex_shader_file_(vertex_shader_file)
, fragment_shader_file_(fragment_shader_file) {
}

VideoEffect::~VideoEffect() {
    delete program_;
}

void VideoEffect::Init() {
    program_ = new ShaderProgram(vertex_shader_file_, fragment_shader_file_);
    
    a_position_ = program_->AttributeLocation("a_position");
    a_texcoord_ = program_->AttributeLocation("a_texcoord");
    u_texture_ = program_->UniformLocation("u_texture");
}

void VideoEffect::SetUniform(const char *name, VideoEffectUniform uniform) {
    uniforms_[name] = uniform;
}

void VideoEffect::Render(VideoFrame input_frame, VideoFrame output_frame) {
    GLfloat positions[] = {
        -1.0f, -1.0f,
        1.0f, -1.0f,
        -1.0f, 1.0f,
        1.0f, 1.0f
    };
    GLfloat texture_coordinates[] = {
        0.0f, 0.0f,
        1.0f, 0.0f,
        0.0f, 1.0f,
        1.0f, 1.0f
    };
    Render(input_frame, output_frame, positions, texture_coordinates);
}

void VideoEffect::Render(VideoFrame input_frame, VideoFrame output_frame, GLfloat *positions, GLfloat *texture_coordinates) {
    glBindTexture(GL_TEXTURE_2D, input_frame.texture_name);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
    
    program_->Use();
    
    BeforeDrawArrays();
    
    glClearColor(0.85, 0.85, 0.85, 1.0);
    glClear(GL_COLOR_BUFFER_BIT);
    
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, input_frame.texture_name);
    glUniform1i(u_texture_, 0);
    
    glEnableVertexAttribArray(a_position_);
    glVertexAttribPointer(a_position_,
                          2,
                          GL_FLOAT,
                          GL_FALSE,
                          0,
                          positions);
    
    glEnableVertexAttribArray(a_texcoord_);
    glVertexAttribPointer(a_texcoord_,
                          2,
                          GL_FLOAT,
                          GL_FALSE,
                          0,
                          texture_coordinates);
    
    glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
}

const char* VideoEffect::get_name() {
    return name_;
}

void VideoEffect::BeforeDrawArrays() {
}

}
}
