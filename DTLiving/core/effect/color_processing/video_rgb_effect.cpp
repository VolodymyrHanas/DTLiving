//
//  video_rgb_effect.cpp
//  DTLiving
//
//  Created by Dan Jiang on 2020/3/19.
//  Copyright © 2020 Dan Thought Studio. All rights reserved.
//

#include "constants.h"
#include "video_rgb_effect.h"

namespace dtliving {
namespace effect {
namespace color_processing {

VideoRGBEffect::VideoRGBEffect(std::string name)
: VideoEffect(name) {
}

void VideoRGBEffect::BeforeDrawArrays(GLsizei width, GLsizei height, int program_index) {
    GLint location = program_->UniformLocation(kVideoRGBEffectRed);
    auto uniform = uniforms_[std::string(kVideoRGBEffectRed)];
    glUniform1fv(location, 1, uniform.u_float);

    location = program_->UniformLocation(kVideoRGBEffectGreen);
    uniform = uniforms_[std::string(kVideoRGBEffectGreen)];
    glUniform1fv(location, 1, uniform.u_float);

    location = program_->UniformLocation(kVideoRGBEffectBlue);
    uniform = uniforms_[std::string(kVideoRGBEffectBlue)];
    glUniform1fv(location, 1, uniform.u_float);
}

}
}
}
