//
//  video_hue_effect.cpp
//  DTLiving
//
//  Created by Dan Jiang on 2020/4/10.
//  Copyright © 2020 Dan Thought Studio. All rights reserved.
//

#include "constants.h"
#include "video_hue_effect.h"

namespace dtliving {
namespace effect {
namespace color_processing {

VideoHueEffect::VideoHueEffect(std::string name)
: VideoEffect(name) {
}

void VideoHueEffect::BeforeDrawArrays(GLsizei width, GLsizei height, int program_index) {
    GLint location = program_->UniformLocation(kVideoHueEffectHue);
    auto uniform = uniforms_[std::string(kVideoHueEffectHue)];
    glUniform1fv(location, 1, uniform.u_float.data());
}

}
}
}
