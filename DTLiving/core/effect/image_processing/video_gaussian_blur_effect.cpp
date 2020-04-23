//
//  video_gaussian_blur_effect.cpp
//  DTLiving
//
//  Created by Dan Jiang on 2020/4/17.
//  Copyright © 2020 Dan Thought Studio. All rights reserved.
//

#include "constants.h"
#include "video_gaussian_blur_effect.h"
#include <cmath>
#include <sstream>

namespace dtliving {
namespace effect {
namespace image_processing {

VideoGaussianBlurEffect::VideoGaussianBlurEffect(std::string name)
: VideoTwoPassTextureSamplingEffect(name)
, blur_radius_in_pixels_(2.0)
, blur_radius_(4)
, sigma_(2.0) {
}

void VideoGaussianBlurEffect::LoadShaderSource() {
    auto blur_vertex = VertexShaderOptimized(blur_radius_, sigma_);
    auto blur_fragment = FragmentShaderOptimized(blur_radius_, sigma_);
    LoadShaderSource2(blur_vertex, blur_fragment,
                      blur_vertex, blur_fragment);
}

void VideoGaussianBlurEffect::BeforeDrawArrays(GLsizei width, GLsizei height, int program_index) {
    auto uniform = uniforms_[std::string(kVideoGaussianBlurEffectBlurRadiusInPixels)];
    GLfloat blur_radius_in_pixels = uniform.u_float.front();
    if (std::round(blur_radius_in_pixels) != blur_radius_in_pixels_) {
        blur_radius_in_pixels_ = std::round(blur_radius_in_pixels);
        
        int blur_radius = 0;
        if (blur_radius_in_pixels_ >= 1) // Avoid a divide-by-zero error here
        {
            // Calculate the number of pixels to sample from by setting a bottom limit for the contribution of the outermost pixel
            GLfloat minimum_weight_to_find_edge_of_sampling_area = 1.0 / 256.0;
            blur_radius = std::floor(std::sqrt(-2.0 * std::pow(blur_radius_in_pixels_, 2.0) * std::log(minimum_weight_to_find_edge_of_sampling_area * std::sqrt(2.0 * M_PI * std::pow(blur_radius_in_pixels_, 2.0)))));
            blur_radius += blur_radius % 2; // There's nothing to gain from handling odd radius sizes, due to the optimizations I use
        }
        
        blur_radius_ = blur_radius;
        sigma_ = blur_radius_in_pixels_;
        
        LoadShaderSource();
        LoadUniform();
    }

    VideoTwoPassTextureSamplingEffect::BeforeDrawArrays(width, height, program_index);
}

std::string VideoGaussianBlurEffect::VertexShaderOptimized(int blur_radius, float sigma) {
    if (blur_radius < 1) {
        return VideoEffect::VertexShader();
    }
    
    // First, generate the normal Gaussian weights for a given sigma
    GLfloat *standard_gaussian_weights = new GLfloat[blur_radius + 1];
    GLfloat sum_of_weights = 0.0;
    for (int i = 0; i < blur_radius + 1; i++) {
        standard_gaussian_weights[i] = (1.0 / std::sqrt(2.0 * 3.141592 * std::pow(sigma, 2.0))) * std::exp(-std::pow(i, 2.0) / (2.0 * std::pow(sigma, 2.0)));
        if (i == 0) {
            sum_of_weights += standard_gaussian_weights[i];
        } else {
            sum_of_weights += 2.0 * standard_gaussian_weights[i];
        }
    }

    // Next, normalize these weights to prevent the clipping of the Gaussian curve at the end of the discrete samples from reducing luminance
    for (int i = 0; i < blur_radius + 1; i++) {
        standard_gaussian_weights[i] = standard_gaussian_weights[i] / sum_of_weights;
    }
    
    // From these weights we calculate the offsets to read interpolated values from
    int number_of_optimized_offsets = std::min(blur_radius / 2 + (blur_radius % 2), 7);
    GLfloat *optimized_gaussian_offsets = new GLfloat[number_of_optimized_offsets];
    for (int i = 0; i < number_of_optimized_offsets; i++) {
        GLfloat first_weight = standard_gaussian_weights[i * 2 + 1];
        GLfloat second_weight = standard_gaussian_weights[i * 2 + 2];
        GLfloat optimized_weight = first_weight + second_weight;
        optimized_gaussian_offsets[i] = (first_weight * (i * 2 + 1) + second_weight * (i * 2 + 2)) / optimized_weight;
    }

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
        os << "v_blurCoordinates[" << i * 2 + 1 << "] = a_texcoord.xy + singleStepOffset * " << optimized_gaussian_offsets[i] << ";\n";
        os << "v_blurCoordinates[" << i * 2 + 2 << "] = a_texcoord.xy - singleStepOffset * " << optimized_gaussian_offsets[i] << ";\n";
    }
    os << "}\n";

    return os.str();
}

std::string VideoGaussianBlurEffect::FragmentShaderOptimized(int blur_radius, float sigma) {
    if (blur_radius < 1) {
        return VideoEffect::FragmentShader();
    }
    
    // First, generate the normal Gaussian weights for a given sigma
    GLfloat *standard_gaussian_weights = new GLfloat[blur_radius + 1];
    GLfloat sum_of_weights = 0.0;
    for (int i = 0; i < blur_radius + 1; i++) {
        standard_gaussian_weights[i] = (1.0 / std::sqrt(2.0 * 3.141592 * std::pow(sigma, 2.0))) * std::exp(-std::pow(i, 2.0) / (2.0 * std::pow(sigma, 2.0)));
        if (i == 0) {
            sum_of_weights += standard_gaussian_weights[i];
        } else {
            sum_of_weights += 2.0 * standard_gaussian_weights[i];
        }
    }

    // Next, normalize these weights to prevent the clipping of the Gaussian curve at the end of the discrete samples from reducing luminance
    for (int i = 0; i < blur_radius + 1; i++) {
        standard_gaussian_weights[i] = standard_gaussian_weights[i] / sum_of_weights;
    }
    
    // From these weights we calculate the offsets to read interpolated values from
    int number_of_optimized_offsets = std::min(blur_radius / 2 + (blur_radius % 2), 7);
    int true_number_of_optimized_offsets = blur_radius / 2 + (blur_radius % 2);

    std::stringstream os;
    os << "varying highp vec2 v_blurCoordinates[" << (1 + number_of_optimized_offsets * 2) << "];\n";
    os << "\n";
    os << "uniform sampler2D u_texture;\n";
    os << "uniform highp float u_texelWidthOffset;\n";
    os << "uniform highp float u_texelHeightOffset;\n";
    os << "\n";
    os << "void main() {\n";
    os << "lowp vec4 sum = vec4(0.0);\n";
    os << "sum += texture2D(u_texture, v_blurCoordinates[0]) * " << standard_gaussian_weights[0] << ";\n";
    for (int i = 0; i < number_of_optimized_offsets; i++) {
        GLfloat first_weight = standard_gaussian_weights[i * 2 + 1];
        GLfloat second_weight = standard_gaussian_weights[i * 2 + 2];
        GLfloat optimized_weight = first_weight + second_weight;
        os << "sum += texture2D(u_texture, v_blurCoordinates[" << i * 2 + 1 << "]) * " << optimized_weight << ";\n";
        os << "sum += texture2D(u_texture, v_blurCoordinates[" << i * 2 + 2 << "]) * " << optimized_weight << ";\n";
    }
    
    if (true_number_of_optimized_offsets > number_of_optimized_offsets) {
        os << "highp vec2 singleStepOffset = vec2(u_texelWidthOffset, u_texelHeightOffset);\n";
    }
    for (int i = number_of_optimized_offsets; i < true_number_of_optimized_offsets; i++) {
        GLfloat first_weight = standard_gaussian_weights[i * 2 + 1];
        GLfloat second_weight = standard_gaussian_weights[i * 2 + 2];
        GLfloat optimized_weight = first_weight + second_weight;
        GLfloat optimized_offset = (first_weight * (i * 2 + 1) + second_weight * (i * 2 + 2)) / optimized_weight;
        os << "sum += texture2D(u_texture, v_blurCoordinates[0] + singleStepOffset * " << optimized_offset << ") * " << optimized_weight << ";\n";
        os << "sum += texture2D(u_texture, v_blurCoordinates[0] - singleStepOffset * " << optimized_offset << ") * " << optimized_weight << ";\n";
    }
    os << "gl_FragColor = sum;\n";
    os << "}\n";

    return os.str();
}

}
}
}
