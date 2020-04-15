//
//  video_effect.cpp
//  DTLiving
//
//  Created by Dan Jiang on 2020/3/12.
//  Copyright © 2020 Dan Thought Studio. All rights reserved.
//

#include "video_effect.h"

namespace dtliving {
namespace effect {

VideoEffect::VideoEffect(const char *name, const char *vertex_shader_file, const char *fragment_shader_file)
: name_(std::string(name))
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
    if (is_orthographic_) {
        u_orthographic_matrix_ = program_->UniformLocation("u_orthographicMatrix");
    }
}

void VideoEffect::SetPositions(GLfloat *positions) {
    if (positions_ != nullptr) {
        delete[] positions_;
    }
    positions_ = positions;
}

void VideoEffect::SetTextureCoordinates(GLfloat *texture_coordinates) {
    if (texture_coordinates_ != nullptr) {
        delete[] texture_coordinates_;
    }
    texture_coordinates_ = texture_coordinates;
}

void VideoEffect::SetUniform(const char *name, VideoEffectUniform uniform) {
    std::string key = std::string(name);
    auto search = uniforms_.find(key);
    if (search != uniforms_.end()) {
        if (search->second.u_int != nullptr) {
            delete[] search->second.u_int;
        }
        if (search->second.u_float != nullptr) {
            delete[] search->second.u_float;
        }
    }
    uniforms_[key] = uniform;
}

void VideoEffect::Render(VideoFrame input_frame, VideoFrame output_frame) {
    GLfloat *positions = nullptr;
    if (positions_ != nullptr) {
        positions = positions_;
    } else {
        GLfloat default_positions[] = {
            -1.0f, -1.0f,
            1.0f, -1.0f,
            -1.0f, 1.0f,
            1.0f, 1.0f
        };
        positions = default_positions;
    }
    
    GLfloat *texture_coordinates = nullptr;
    if (texture_coordinates_ != nullptr) {
        texture_coordinates = texture_coordinates_;
    } else {
        GLfloat default_texture_coordinates[] = {
            0.0f, 0.0f,
            1.0f, 0.0f,
            0.0f, 1.0f,
            1.0f, 1.0f
        };
        texture_coordinates = default_texture_coordinates;
    }
    
    Render(input_frame, output_frame, positions, texture_coordinates);
}

void VideoEffect::Render(VideoFrame input_frame, VideoFrame output_frame, GLfloat *positions, GLfloat *texture_coordinates) {
    glBindTexture(GL_TEXTURE_2D, input_frame.texture_name);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
    
    program_->Use();
    
    if (is_orthographic_) {
        // for right now, input frame size == output frame size == view port
        GLfloat normalizedHeight = GLfloat(output_frame.height) / GLfloat(output_frame.width);
        *(positions + 1) = -normalizedHeight;
        *(positions + 3) = -normalizedHeight;
        *(positions + 5) = normalizedHeight;
        *(positions + 7) = normalizedHeight;
        
        caculateOrthographicMatrix(GLfloat(output_frame.width),
                                   GLfloat(output_frame.height));
    }
    
    BeforeDrawArrays();
    
    glClearColor(clear_color_red_, clear_color_green_, clear_color_blue_, clear_color_alpha_);
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

void VideoEffect::caculateOrthographicMatrix(GLfloat width, GLfloat height) {
    GLfloat left = -1.0;
    GLfloat right = 1.0;
    GLfloat bottom = -1.0;
    GLfloat top = 1.0;
    GLfloat near = -1.0;
    GLfloat far = 1.0;
    if (!ignore_aspect_ratio_) {
        bottom = -1.0 * height / width;
        top = 1.0 * height / width;
    }

    GLfloat r_l = right - left;
    GLfloat t_b = top - bottom;
    GLfloat f_n = far - near;
    GLfloat tx = - (right + left) / (right - left);
    GLfloat ty = - (top + bottom) / (top - bottom);
    GLfloat tz = - (far + near) / (far - near);
    
    GLfloat scale = 2.0;
    
    GLfloat matrix[16] = {
        scale / r_l, 0.0, 0.0, tx,
        0.0, scale / t_b, 0.0, ty,
        0.0, 0.0, scale / f_n, tz,
        0.0, 0.0, 0.0, 1.0
    };
    
    glUniformMatrix4fv(u_orthographic_matrix_, 1, false, matrix);
}

void VideoEffect::BeforeDrawArrays() {}

}
}
