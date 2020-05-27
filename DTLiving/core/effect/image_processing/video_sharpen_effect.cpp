//
//  video_sharpen_effect.cpp
//  DTLiving
//
//  Created by Dan Jiang on 2020/5/26.
//  Copyright © 2020 Dan Thought Studio. All rights reserved.
//

#include "video_sharpen_effect.h"

#include "constants.h"

namespace dtliving {
namespace effect {
namespace image_processing {

VideoSharpenEffect::VideoSharpenEffect(std::string name)
: VideoEffect(name) {
}

void VideoSharpenEffect::LoadUniform() {
    VideoEffect::LoadUniform();
    
    u_texelWidth_ = program_->UniformLocation("u_imageWidthFactor");
    u_texelHeight_ = program_->UniformLocation("u_imageHeightFactor");
}

void VideoSharpenEffect::BeforeDrawArrays(GLsizei width, GLsizei height, int program_index) {
    glUniform1f(u_texelWidth_, 1.0 / width);
    glUniform1f(u_texelHeight_, 1.0 / height);

    GLint location = program_->UniformLocation(kVideoSharpenEffectSharpness);
    auto uniform = uniforms_[std::string(kVideoSharpenEffectSharpness)];
    glUniform1fv(location, 1, uniform.u_float.data());
}

}
}
}
