//
//  video_3x3_convolution_effect.cpp
//  DTLiving
//
//  Created by Dan Jiang on 2020/5/9.
//  Copyright © 2020 Dan Thought Studio. All rights reserved.
//

#include "constants.h"
#include "video_3x3_convolution_effect.h"
#include <sstream>

namespace dtliving {
namespace effect {

std::string Video3x3ConvolutionEffect::FragmentShader() {
    std::stringstream os;
    os << "precision highp float;\n";
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
    os << "uniform sampler2D u_texture;\n";
    os << "\n";
    os << "uniform mediump mat3 u_convolutionMatrix;\n";
    os << "\n";
    os << "void main() {\n";
    os << "mediump vec3 bottomColor = texture2D(u_texture, v_bottomTexcoord).rgb;\n";
    os << "mediump vec3 bottomLeftColor = texture2D(u_texture, v_bottomLeftTexcoord).rgb;\n";
    os << "mediump vec3 bottomRightColor = texture2D(u_texture, v_bottomRightTexcoord).rgb;\n";
    os << "mediump vec4 centerColor = texture2D(u_texture, v_texcoord);\n";
    os << "mediump vec3 leftColor = texture2D(u_texture, v_leftTexcoord).rgb;\n";
    os << "mediump vec3 rightColor = texture2D(u_texture, v_rightTexcoord).rgb;\n";
    os << "mediump vec3 topColor = texture2D(u_texture, v_topTexcoord).rgb;\n";
    os << "mediump vec3 topRightColor = texture2D(u_texture, v_topRightTexcoord).rgb;\n";
    os << "mediump vec3 topLeftColor = texture2D(u_texture, v_topLeftTexcoord).rgb;\n";
    os << "mediump vec3 resultColor = topLeftColor * u_convolutionMatrix[0][0] + topColor * u_convolutionMatrix[0][1] + topRightColor * u_convolutionMatrix[0][2];\n";
    os << "resultColor += leftColor * u_convolutionMatrix[1][0] + centerColor.rgb * u_convolutionMatrix[1][1] + rightColor * u_convolutionMatrix[1][2];\n";
    os << "resultColor += bottomLeftColor * u_convolutionMatrix[2][0] + bottomColor * u_convolutionMatrix[2][1] + bottomRightColor * u_convolutionMatrix[2][2];\n";
    os << "gl_FragColor = vec4(resultColor, centerColor.a);\n";
    os << "}\n";
    return os.str();
}

Video3x3ConvolutionEffect::Video3x3ConvolutionEffect(std::string name)
: Video3x3TextureSamplingEffect(name) {
}

void Video3x3ConvolutionEffect::LoadShaderSource() {
    auto convolution_fragment = FragmentShader();
    Video3x3TextureSamplingEffect::LoadFragmentShaderSource(convolution_fragment);
}

void Video3x3ConvolutionEffect::BeforeDrawArrays(GLsizei width, GLsizei height, int program_index) {
    Video3x3TextureSamplingEffect::BeforeDrawArrays(width, height, program_index);
    
    GLint location = program_->UniformLocation(kVideo3x3ConvolutionEffectConvolutionMatrix);
    auto uniform = uniforms_[std::string(kVideo3x3ConvolutionEffectConvolutionMatrix)];
    glUniformMatrix3fv(location, 1, false, uniform.u_float.data());
}

}
}
