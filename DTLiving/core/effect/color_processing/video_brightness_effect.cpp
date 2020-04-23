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

VideoBrightnessEffect::VideoBrightnessEffect(std::string name)
: VideoEffect(name) {
}

void VideoBrightnessEffect::BeforeDrawArrays(GLsizei width, GLsizei height, int program_index) {
    GLint location = program_->UniformLocation(kVideoBrightnessEffectBrightness);
    auto uniform = uniforms_[std::string(kVideoBrightnessEffectBrightness)];
    glUniform1fv(location, 1, uniform.u_float.data());        
}

}
}
}
