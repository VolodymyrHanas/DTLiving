//
//  video_effect.cpp
//  DTLiving
//
//  Created by Dan Jiang on 2020/3/12.
//  Copyright © 2020 Dan Thought Studio. All rights reserved.
//

#include "video_effect.h"

#include <sstream>

namespace dtliving {
namespace effect {

std::string VideoEffect::VertexShader() {
    std::stringstream os;
    os << "attribute vec4 a_position;\n";
    os << "attribute vec4 a_texcoord;\n";
    os << "\n";
    os << "varying vec2 v_texcoord;\n";
    os << "\n";
    os << "void main() {\n";
    os << "v_texcoord = a_texcoord.xy;\n";
    os << "gl_Position = a_position;\n";
    os << "}\n";
    return os.str();
}

std::string VideoEffect::FragmentShader() {
    std::stringstream os;
    os << "varying highp vec2 v_texcoord;\n";
    os << "\n";
    os << "uniform sampler2D u_texture;\n";
    os << "\n";
    os << "void main() {\n";
    os << "gl_FragColor = texture2D(u_texture, v_texcoord);\n";
    os << "}\n";
    return os.str();
}

std::string VideoEffect::GrayScaleFragmentShader() {
    std::stringstream os;
    os << "varying highp vec2 v_texcoord;\n";
    os << "\n";
    os << "uniform sampler2D u_texture;\n";
    os << "\n";
    os << "const mediump vec3 luminanceWeighting = vec3(0.2125, 0.7154, 0.0721);\n";
    os << "\n";
    os << "void main() {\n";
    os << "lowp vec4 textureColor = texture2D(u_texture, v_texcoord);\n";
    os << "highp float luminance = dot(textureColor.rgb, luminanceWeighting);\n";
    os << "gl_FragColor = vec4(vec3(luminance), textureColor.a);\n";
    os << "}\n";
    return os.str();
}

std::vector<GLfloat> VideoEffect::CaculateOrthographicMatrix(GLfloat width, GLfloat height, bool ignore_aspect_ratio) {
    GLfloat left = -1.0;
    GLfloat right = 1.0;
    GLfloat bottom = -1.0;
    GLfloat top = 1.0;
    GLfloat near = -1.0;
    GLfloat far = 1.0;
    
    if (!ignore_aspect_ratio) {
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
    
    std::vector<GLfloat> matrix {
        scale / r_l, 0.0, 0.0, tx,
        0.0, scale / t_b, 0.0, ty,
        0.0, 0.0, scale / f_n, tz,
        0.0, 0.0, 0.0, 1.0
    };
    
    return matrix;
}

VideoEffect::VideoEffect(std::string name)
: name_(name)
, positions_({ -1, -1, 1, -1, -1, 1, 1, 1 })
, texture_coordinates_({ 0, 0, 1, 0, 0, 1, 1, 1 })
, png_decoder_(new decoder::image::PngDecoder()) {
}

VideoEffect::~VideoEffect() {
    delete program_;
}

void VideoEffect::LoadShaderFile(std::string vertex_shader_file, std::string fragment_shader_file) {
    program_ = new ShaderProgram();
    program_->CompileFile(vertex_shader_file.c_str(), fragment_shader_file.c_str());
}

void VideoEffect::LoadShaderSource() {
}

void VideoEffect::LoadShaderSource(std::string vertex_shader_source, std::string fragment_shader_source) {
    program_ = new ShaderProgram();
    program_->CompileSource(vertex_shader_source.c_str(), fragment_shader_source.c_str());
}

void VideoEffect::LoadUniform() {
    a_position_ = program_->AttributeLocation("a_position");
    a_texcoord_ = program_->AttributeLocation("a_texcoord");
    u_texture_ = program_->UniformLocation("u_texture");
}

void VideoEffect::LoadResources(std::vector<std::string> resources) {    
}

void VideoEffect::SetPositions(std::vector<GLfloat> positions) {
    positions_ = positions;
}

void VideoEffect::SetTextureCoordinates(std::vector<GLfloat> texture_coordinates) {
    texture_coordinates_ = texture_coordinates;
}

void VideoEffect::SetUniform(std::string name, VideoEffectUniform uniform) {
    uniforms_[name] = uniform;
}

bool VideoEffect::Update(double delta, GLsizei width, GLsizei height) {
    time_since_first_update_ += delta; // delta is zero for first time
    if (duration_ < 0) {
        Update(width, height);
        return true;
    } else {
        if (time_since_first_update_ > duration_) {
            return false;
        }
        
        Update(width, height);
        return true;
    }
}

void VideoEffect::Update(GLsizei width, GLsizei height) {
}

void VideoEffect::Render(VideoFrame input_frame, VideoFrame output_frame) {
    Render(input_frame, output_frame, positions_, texture_coordinates_);
}

void VideoEffect::Render(VideoFrame input_frame, VideoFrame output_frame, std::vector<GLfloat> positions, std::vector<GLfloat> texture_coordinates) {
    glBindTexture(GL_TEXTURE_2D, input_frame.texture_name);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
    
    glFramebufferTexture2D(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_TEXTURE_2D, output_frame.texture_name, 0);

    program_->Use();
            
    glClearColor(clear_color_.x, clear_color_.y, clear_color_.z, clear_color_.w);
    glClear(GL_COLOR_BUFFER_BIT);
    
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, input_frame.texture_name);
    glUniform1i(u_texture_, 0);
    
    BeforeSetPositions(output_frame.width, output_frame.height, 0);
        
    glEnableVertexAttribArray(a_position_);
    glVertexAttribPointer(a_position_,
                          2,
                          GL_FLOAT,
                          GL_FALSE,
                          0,
                          positions.data());
    
    glEnableVertexAttribArray(a_texcoord_);
    glVertexAttribPointer(a_texcoord_,
                          2,
                          GL_FLOAT,
                          GL_FALSE,
                          0,
                          texture_coordinates.data());
    
    BeforeDrawArrays(output_frame.width, output_frame.height, 0);

    glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
}

void VideoEffect::BeforeSetPositions(GLsizei width, GLsizei height, int program_index) {
}

void VideoEffect::BeforeDrawArrays(GLsizei width, GLsizei height, int program_index) {
}

}
}
