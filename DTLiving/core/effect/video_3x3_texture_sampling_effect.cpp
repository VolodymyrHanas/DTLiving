//
//  video_3x3_texture_sampling_effect.cpp
//  DTLiving
//
//  Created by Dan Jiang on 2020/4/23.
//  Copyright © 2020 Dan Thought Studio. All rights reserved.
//

#include "constants.h"
#include "video_3x3_texture_sampling_effect.h"
#include <sstream>

namespace dtliving {
namespace effect {

std::string Video3x3TextureSamplingEffect::VertexShader() {
    std::stringstream os;
    os << "attribute vec4 a_position;\n";
    os << "attribute vec4 a_texcoord;\n";
    os << "\n";
    os << "uniform float u_texelWidth;\n";
    os << "uniform float u_texelHeight;\n";
    os << "\n";
    os << "varying vec2 v_texcoord;\n";
    os << "varying vec2 v_leftTexcoord;\n";
    os << "varying vec2 v_rightTexcoord;\n";
    os << "\n";
    os << "varying vec2 v_topTexcoord;\n";
    os << "varying vec2 v_topLeftTexcoord;\n";
    os << "varying vec2 v_topRightTexcoord;\n";
    os << "\n";
    os << "varying vec2 v_bottomTexcoord;\n";
    os << "varying vec2 v_bottomLeftTexcoord;\n";
    os << "varying vec2 v_bottomRightTexcoord;\n";
    os << "\n";
    os << "void main() {\n";
    os << "gl_Position = a_position;\n";
    os << "\n";
    os << "vec2 widthStep = vec2(u_texelWidth, 0.0);\n";
    os << "vec2 heightStep = vec2(0.0, u_texelHeight);\n";
    os << "vec2 widthHeightStep = vec2(u_texelWidth, u_texelHeight);\n";
    os << "vec2 widthNegativeHeightStep = vec2(u_texelWidth, -u_texelHeight);\n";
    os << "\n";
    os << "v_texcoord = a_texcoord.xy;\n";
    os << "v_leftTexcoord = a_texcoord.xy - widthStep;\n";
    os << "v_rightTexcoord = a_texcoord.xy + widthStep;\n";
    os << "\n";
    os << "v_topTexcoord = a_texcoord.xy - heightStep;\n";
    os << "v_topLeftTexcoord = a_texcoord.xy - widthHeightStep;\n";
    os << "v_topRightTexcoord = a_texcoord.xy + widthNegativeHeightStep;\n";
    os << "\n";
    os << "v_bottomTexcoord = a_texcoord.xy + heightStep;\n";
    os << "v_bottomLeftTexcoord = a_texcoord.xy - widthNegativeHeightStep;\n";
    os << "v_bottomRightTexcoord = a_texcoord.xy + widthHeightStep;\n";
    os << "}\n";
    return os.str();
}

Video3x3TextureSamplingEffect::Video3x3TextureSamplingEffect(std::string name)
: VideoEffect(name) {
}

void Video3x3TextureSamplingEffect::LoadFragmentShaderSource(std::string fragment_shader_source) {
    LoadShaderSource(VertexShader(), fragment_shader_source);
}

void Video3x3TextureSamplingEffect::LoadUniform() {
    VideoEffect::LoadUniform();
    
    u_texelWidth_ = program_->UniformLocation("u_texelWidth");
    u_texelHeight_ = program_->UniformLocation("u_texelHeight");
}

void Video3x3TextureSamplingEffect::BeforeDrawArrays(GLsizei width, GLsizei height, int program_index) {
    glUniform1f(u_texelWidth_, 1.0 / width);
    glUniform1f(u_texelHeight_, 1.0 / height);
}

}
}
