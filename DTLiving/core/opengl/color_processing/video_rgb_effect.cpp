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
namespace opengl {
namespace color_processing {

VideoRGBEffect::VideoRGBEffect(const char *name, const char *vertex_shader_file, const char *fragment_shader_file)
: VideoEffect(name, vertex_shader_file, fragment_shader_file) {
}

void VideoRGBEffect::BeforeDrawArrays() {
    GLint red_location = program_->UniformLocation(kVideoRGBEffectRed);
    auto red = uniforms_[kVideoRGBEffectRed];
    glUniform1f(red_location, red.u_float);

    GLint green_location = program_->UniformLocation(kVideoRGBEffectGreen);
    auto green = uniforms_[kVideoRGBEffectGreen];
    glUniform1f(green_location, green.u_float);

    GLint blue_location = program_->UniformLocation(kVideoRGBEffectBlue);
    auto blue = uniforms_[kVideoRGBEffectBlue];
    glUniform1f(blue_location, blue.u_float);
}

}
}
}
