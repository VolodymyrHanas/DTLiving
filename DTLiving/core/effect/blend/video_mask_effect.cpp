//
//  video_mask_effect.cpp
//  DTLiving
//
//  Created by Dan Jiang on 2020/5/9.
//  Copyright © 2020 Dan Thought Studio. All rights reserved.
//

#include "constants.h"
#include "video_mask_effect.h"

namespace dtliving {
namespace effect {
namespace blend {

VideoMaskEffect::VideoMaskEffect(std::string name)
: VideoTwoInputEffect(name) {
}

void VideoMaskEffect::BeforeDrawArrays(GLsizei width, GLsizei height, int program_index) {
    VideoTwoInputEffect::BeforeDrawArrays(width, height, program_index);
    
    GLint location = program_->UniformLocation(kVideoMaskEffectColor);
    auto uniform = uniforms_[std::string(kVideoMaskEffectColor)];
    glUniform4fv(location, 1, uniform.u_float.data());
}

}
}
}
