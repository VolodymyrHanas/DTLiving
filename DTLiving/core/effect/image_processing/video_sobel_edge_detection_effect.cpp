//
//  video_sobel_edge_detection_effect.cpp
//  DTLiving
//
//  Created by Dan Jiang on 2020/4/23.
//  Copyright © 2020 Dan Thought Studio. All rights reserved.
//

#include "constants.h"
#include "video_sobel_edge_detection_effect.h"
#include "video_3x3_texture_sampling_effect.h"
#include <sstream>

namespace dtliving {
namespace effect {
namespace image_processing {

std::string VideoSobelEdgeDetectionEffect::FragmentShader() {
    std::stringstream os;
    os << "precision mediump float;\n";
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
    os << "uniform float u_edgeStrength;\n";
    os << "\n";
    os << "void main() {\n";
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
    os << "float mag = length(vec2(h, v)) * u_edgeStrength;\n";
    os << "gl_FragColor = vec4(vec3(mag), 1.0);\n";
    os << "}\n";
    return os.str();
}

VideoSobelEdgeDetectionEffect::VideoSobelEdgeDetectionEffect(std::string name)
: VideoTwoPassEffect(name) {
}

void VideoSobelEdgeDetectionEffect::LoadShaderSource() {
    auto vertex = VideoEffect::VertexShader();
    auto gray_scale_fragment = VideoEffect::GrayScaleFragmentShader();
    auto texture_sampling_vertex = Video3x3TextureSamplingEffect::VertexShader();
    auto sobel_edge_detection_fragment = VideoSobelEdgeDetectionEffect::FragmentShader();
    VideoTwoPassEffect::LoadShaderSource(vertex, gray_scale_fragment,
                                         texture_sampling_vertex, sobel_edge_detection_fragment);
}

void VideoSobelEdgeDetectionEffect::LoadUniform() {
    VideoTwoPassEffect::LoadUniform();
    
    u_texelWidth_ = program2_->UniformLocation("u_texelWidth");
    u_texelHeight_ = program2_->UniformLocation("u_texelHeight");
}

void VideoSobelEdgeDetectionEffect::BeforeDrawArrays(GLsizei width, GLsizei height, int program_index) {
    if (program_index == 1) {
        glUniform1f(u_texelWidth_, 1.0 / width);
        glUniform1f(u_texelHeight_, 1.0 / height);
        
        GLint location = program2_->UniformLocation(kVideoSobelEdgeDetectionEffectEdgeStrength);
        auto uniform = uniforms_[std::string(kVideoSobelEdgeDetectionEffectEdgeStrength)];
        glUniform1fv(location, 1, uniform.u_float.data());
    }
}

}
}
}
