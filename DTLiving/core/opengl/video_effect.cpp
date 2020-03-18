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

const char *kVideoBrightnessEffect = "effect_brightness";
const char *kVideoBrightnessEffectBrightness = "u_brightness";

const char *kVideoRGBEffect = "effect_rgb";
const char *kVideoRGBEffectRed = "u_redAdjustment";
const char *kVideoRGBEffectGreen = "u_greenAdjustment";
const char *kVideoRGBEffectBlue = "u_blueAdjustment";

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

void VideoEffect::SetUniformFloat(const char *name, GLfloat value) {
    program_->Use();
    GLint location = program_->UniformLocation(name);
    glUniform1f(location, value);
}

void VideoEffect::Render(GLuint input_texture, GLfloat *positions, GLfloat *texture_coordinates) {
    glBindTexture(GL_TEXTURE_2D, input_texture);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
    
    program_->Use();
    
    glClearColor(0.85, 0.85, 0.85, 1.0);
    glClear(GL_COLOR_BUFFER_BIT);
    
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, input_texture);
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

}
}
