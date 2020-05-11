//
//  video_toon_effect.cpp
//  DTLiving
//
//  Created by Dan Jiang on 2020/5/9.
//  Copyright © 2020 Dan Thought Studio. All rights reserved.
//

#include "constants.h"
#include "video_toon_effect.h"
#include <sstream>
#include <iostream>

namespace dtliving {
namespace effect {
namespace effect {

std::string VideoToonEffect::FragmentShader() {
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
    os << "uniform highp float u_threshold;\n";
    os << "uniform highp float u_quantizationLevels;\n";
    os << "\n";
    os << "void main() {\n";
    os << "vec4 textureColor = texture2D(u_texture, v_texcoord);\n";
    os << "float bottomLeftIntensity = texture2D(u_texture, v_bottomLeftTexcoord).r;\n";
    os << "float topRightIntensity = texture2D(u_texture, v_topRightTexcoord).r;\n";
    os << "float topLeftIntensity = texture2D(u_texture, v_topLeftTexcoord).r;\n";
    os << "float bottomRightIntensity = texture2D(u_texture, v_bottomRightTexcoord).r;\n";
    os << "float leftIntensity = texture2D(u_texture, v_leftTexcoord).r;\n";
    os << "float rightIntensity = texture2D(u_texture, v_rightTexcoord).r;\n";
    os << "float bottomIntensity = texture2D(u_texture, v_bottomTexcoord).r;\n";
    os << "float topIntensity = texture2D(u_texture, v_topTexcoord).r;\n";
    os << "\n";
    os << "float v = -topLeftIntensity - 2.0 * topIntensity - topRightIntensity + bottomLeftIntensity + 2.0 * bottomIntensity + bottomRightIntensity;\n";
    os << "float h = -bottomLeftIntensity - 2.0 * leftIntensity - topLeftIntensity + bottomRightIntensity + 2.0 * rightIntensity + topRightIntensity;\n";
    os << "float mag = length(vec2(h, v));\n"; // sobel edge detection
    os << "vec3 posterizedImageColor = floor((textureColor.rgb * u_quantizationLevels) + 0.5) / u_quantizationLevels;\n"; // quantizes the colors present in the image to give a cartoon-like
    os << "float thresholdTest = 1.0 - step(u_threshold, mag);\n"; // place a black border around objects
    os << "gl_FragColor = vec4(posterizedImageColor * thresholdTest, textureColor.a);\n";
    os << "}\n";
    return os.str();
}

VideoToonEffect::VideoToonEffect(std::string name)
: Video3x3TextureSamplingEffect(name) {
}

void VideoToonEffect::LoadShaderSource() {
    auto fragment = FragmentShader();
    Video3x3TextureSamplingEffect::LoadFragmentShaderSource(fragment);
}

void VideoToonEffect::BeforeDrawArrays(GLsizei width, GLsizei height, int program_index) {
    Video3x3TextureSamplingEffect::BeforeDrawArrays(width, height, program_index);

    GLint location = program_->UniformLocation(kVideoToonEffectThreshold);
    auto uniform = uniforms_[std::string(kVideoToonEffectThreshold)];
    glUniform1fv(location, 1, uniform.u_float.data());
    
    location = program_->UniformLocation(kVideoToonEffectQuantizationLevels);
    uniform = uniforms_[std::string(kVideoToonEffectQuantizationLevels)];
    glUniform1fv(location, 1, uniform.u_float.data());
}

}
}
}
