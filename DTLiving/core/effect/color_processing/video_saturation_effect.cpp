//
//  video_saturation_effect.cpp
//  DTLiving
//
//  Created by Dan Jiang on 2020/4/7.
//  Copyright © 2020 Dan Thought Studio. All rights reserved.
//

#include "constants.h"
#include "video_saturation_effect.h"

namespace dtliving {
namespace effect {
namespace color_processing {

VideoSaturationEffect::VideoSaturationEffect(std::string name)
: VideoEffect(name) {
}

void VideoSaturationEffect::BeforeDrawArrays(GLsizei width, GLsizei height, int program_index) {
    GLint location = program_->UniformLocation(kVideoSaturationEffectSaturation);
    auto uniform = uniforms_[std::string(kVideoSaturationEffectSaturation)];
    glUniform1fv(location, 1, uniform.u_float.data());
}

}
}
}
