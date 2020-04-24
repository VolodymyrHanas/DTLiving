//
//  video_two_pass_texture_sampling_effect.cpp
//  DTLiving
//
//  Created by Dan Jiang on 2020/4/17.
//  Copyright © 2020 Dan Thought Studio. All rights reserved.
//

#include "video_two_pass_texture_sampling_effect.h"

namespace dtliving {
namespace effect {

VideoTwoPassTextureSamplingEffect::VideoTwoPassTextureSamplingEffect(std::string name)
: VideoTwoPassEffect(name)
, vertical_texel_spacing_(1)
, horizontal_texel_spacing_(1) {
}

void VideoTwoPassTextureSamplingEffect::LoadUniform() {
    VideoTwoPassEffect::LoadUniform();
    
    u_vertical_texelWidthOffset_ = program_->UniformLocation("u_texelWidthOffset");
    u_vertical_texelHeightOffset_ = program_->UniformLocation("u_texelHeightOffset");
    u_horizontal_texelWidthOffset_ = program2_->UniformLocation("u_texelWidthOffset");
    u_horizontal_texelHeightOffset_ = program2_->UniformLocation("u_texelHeightOffset");
}

void VideoTwoPassTextureSamplingEffect::BeforeDrawArrays(GLsizei width, GLsizei height, int program_index) {
    if (program_index == 0) {
        glUniform1f(u_vertical_texelWidthOffset_, 0);
        glUniform1f(u_vertical_texelHeightOffset_, vertical_texel_spacing_ / height);
    } else {
        glUniform1f(u_horizontal_texelWidthOffset_, horizontal_texel_spacing_ / width);
        glUniform1f(u_horizontal_texelHeightOffset_, 0);
    }
}

}
}
