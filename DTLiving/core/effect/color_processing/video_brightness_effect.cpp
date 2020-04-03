//
//  video_brightness_effect.cpp
//  DTLiving
//
//  Created by Dan Jiang on 2020/3/19.
//  Copyright © 2020 Dan Thought Studio. All rights reserved.
//

#include "constants.h"
#include "video_brightness_effect.h"

namespace dtliving {
namespace effect {
namespace color_processing {

VideoBrightnessEffect::VideoBrightnessEffect(const char *name, const char *vertex_shader_file, const char *fragment_shader_file)
: VideoEffect(name, vertex_shader_file, fragment_shader_file) {
}

void VideoBrightnessEffect::BeforeDrawArrays() {
    GLint location = program_->UniformLocation(kVideoBrightnessEffectBrightness);
    auto brightness = uniforms_[std::string(kVideoBrightnessEffectBrightness)];
    glUniform1f(location, brightness.u_float);    
}

}
}
}
