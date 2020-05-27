//
//  video_bilateral_effect.cpp
//  DTLiving
//
//  Created by Dan Jiang on 2020/5/26.
//  Copyright © 2020 Dan Thought Studio. All rights reserved.
//
//  音视频开发进阶指南：基于 Android 与 iOS 平台的实践 — 9.2.4 双边滤波算法 / 9.4.3 美颜效果器

#include "video_bilateral_effect.h"

#include "constants.h"

namespace dtliving {
namespace effect {
namespace image_processing {

VideoBilateralEffect::VideoBilateralEffect(std::string name)
: VideoTwoPassTextureSamplingEffect(name) {
    set_texel_spacing_multiplier(4.0);
}

void VideoBilateralEffect::LoadShaderFile(std::string vertex_shader_file, std::string fragment_shader_file) {
    VideoEffect::LoadShaderFile(vertex_shader_file, fragment_shader_file);
    
    program2_ = new ShaderProgram();
    program2_->CompileFile(vertex_shader_file.c_str(), fragment_shader_file.c_str());
}

void VideoBilateralEffect::BeforeDrawArrays(GLsizei width, GLsizei height, int program_index) {
    VideoTwoPassTextureSamplingEffect::BeforeDrawArrays(width, height, program_index);
    
    GLint location = -1;
    if (program_index == 0) {
        location = program_->UniformLocation(kVideoBilateralEffectDistanceNormalizationFactor);
    } else {
        location = program2_->UniformLocation(kVideoBilateralEffectDistanceNormalizationFactor);
    }
    auto uniform = uniforms_[kVideoBilateralEffectDistanceNormalizationFactor];
    glUniform1fv(location, 1, uniform.u_float.data());
}

}
}
}
