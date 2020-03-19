//
//  video_brightness_effect.cpp
//  DTLiving
//
//  Created by Dan Jiang on 2020/3/19.
//  Copyright © 2020 Dan Thought Studio. All rights reserved.
//

#include "video_brightness_effect.h"
#include "constants.h"

namespace dtliving {
namespace opengl {
namespace color_processing {

void VideoBrightnessEffect::BeforeDrawArrays() {
    GLint location = program_->UniformLocation(kVideoBrightnessEffectBrightness);
    auto brightness = uniforms_[kVideoBrightnessEffectBrightness];
    glUniform1f(location, brightness.u_float);    
}

}
}
}
