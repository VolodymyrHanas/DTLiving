//
//  video_box_blur_effect.cpp
//  DTLiving
//
//  Created by Dan Jiang on 2020/4/21.
//  Copyright © 2020 Dan Thought Studio. All rights reserved.
//

#include "constants.h"
#include "video_box_blur_effect.h"
#include <cmath>
#include <sstream>

namespace dtliving {
namespace effect {
namespace image_processing {

VideoBoxBlurEffect::VideoBoxBlurEffect(std::string name)
: VideoTwoPassTextureSamplingEffect(name)
, blur_radius_(4) {
}

void VideoBoxBlurEffect::LoadShaderSource() {
    auto blur_vertex = VertexShaderOptimized(blur_radius_);
    auto blur_fragment = FragmentShaderOptimized(blur_radius_);
    LoadShaderSource2(blur_vertex, blur_fragment,
                      blur_vertex, blur_fragment);
}

void VideoBoxBlurEffect::BeforeDrawArrays(GLsizei width, GLsizei height, int program_index) {
    auto uniform = uniforms_[std::string(kVideoBoxBlurEffectBlurRadiusInPixels)];
    GLfloat new_value = uniform.u_float.front();
    int blur_radius = (int)std::round(std::round(new_value / 2.0) * 2.0); // For now, only do even radii
    if (blur_radius_ != blur_radius) {
        blur_radius_ = blur_radius;
        
        LoadShaderSource();
        LoadUniform();
    }

    VideoTwoPassTextureSamplingEffect::BeforeDrawArrays(width, height, program_index);
}

std::string VideoBoxBlurEffect::VertexShaderOptimized(int blur_radius) {
    if (blur_radius < 1) {
        return VideoEffect::VertexShader();
    }
        
    // From these weights we calculate the offsets to read interpolated values from
    int number_of_optimized_offsets = std::min(blur_radius / 2 + (blur_radius % 2), 7);

    std::stringstream os;
    os << "attribute vec4 a_position;\n";
    os << "attribute vec4 a_texcoord;\n";
    os << "\n";
    os << "uniform float u_texelWidthOffset;\n";
    os << "uniform float u_texelHeightOffset;\n";
    os << "\n";
    os << "varying vec2 v_blurCoordinates[" << (1 + number_of_optimized_offsets * 2) << "];\n";
    os << "\n";
    os << "void main() {\n";
    os << "gl_Position = a_position;\n";
    os << "\n";
    os << "vec2 singleStepOffset = vec2(u_texelWidthOffset, u_texelHeightOffset);\n";
    os << "v_blurCoordinates[0] = a_texcoord.xy;\n";
    for (int i = 0; i < number_of_optimized_offsets; i++) {
        GLfloat optimized_offset = GLfloat(i * 2) + 1.5;
        os << "v_blurCoordinates[" << i * 2 + 1 << "] = a_texcoord.xy + singleStepOffset * " << optimized_offset << ";\n";
        os << "v_blurCoordinates[" << i * 2 + 2 << "] = a_texcoord.xy - singleStepOffset * " << optimized_offset << ";\n";
    }
    os << "}\n";

    return os.str();
}

std::string VideoBoxBlurEffect::FragmentShaderOptimized(int blur_radius) {
    if (blur_radius < 1) {
        return VideoEffect::FragmentShader();
    }
        
    // From these weights we calculate the offsets to read interpolated values from
    int number_of_optimized_offsets = std::min(blur_radius / 2 + (blur_radius % 2), 7);
    int true_number_of_optimized_offsets = blur_radius / 2 + (blur_radius % 2);

    GLfloat box_weight = 1.0 / (GLfloat)((blur_radius * 2) + 1);

    std::stringstream os;
    os << "varying highp vec2 v_blurCoordinates[" << (1 + number_of_optimized_offsets * 2) << "];\n";
    os << "\n";
    os << "uniform sampler2D u_texture;\n";
    os << "uniform highp float u_texelWidthOffset;\n";
    os << "uniform highp float u_texelHeightOffset;\n";
    os << "\n";
    os << "void main() {\n";
    os << "lowp vec4 sum = vec4(0.0);\n";
    os << "sum += texture2D(u_texture, v_blurCoordinates[0]) * " << box_weight << ";\n";
    for (int i = 0; i < number_of_optimized_offsets; i++) {
        os << "sum += texture2D(u_texture, v_blurCoordinates[" << i * 2 + 1 << "]) * " << box_weight * 2.0 << ";\n";
        os << "sum += texture2D(u_texture, v_blurCoordinates[" << i * 2 + 2 << "]) * " << box_weight * 2.0 << ";\n";
    }
    
    if (true_number_of_optimized_offsets > number_of_optimized_offsets) {
        os << "highp vec2 singleStepOffset = vec2(u_texelWidthOffset, u_texelHeightOffset);\n";
    }
    for (int i = number_of_optimized_offsets; i < true_number_of_optimized_offsets; i++) {
        GLfloat optimized_offset = GLfloat(i * 2) + 1.5;
        os << "sum += texture2D(u_texture, v_blurCoordinates[0] + singleStepOffset * " << optimized_offset << ") * " << box_weight * 2.0 << ";\n";
        os << "sum += texture2D(u_texture, v_blurCoordinates[0] - singleStepOffset * " << optimized_offset << ") * " << box_weight * 2.0 << ";\n";
    }
    os << "gl_FragColor = sum;\n";
    os << "}\n";

    return os.str();
}

}
}
}
