//
//  video_alpha_blend_effect.cpp
//  DTLiving
//
//  Created by Dan Jiang on 2020/5/9.
//  Copyright © 2020 Dan Thought Studio. All rights reserved.
//

#include "constants.h"
#include "video_alpha_blend_effect.h"

namespace dtliving {
namespace effect {
namespace blend {

VideoAlphaBlendEffect::VideoAlphaBlendEffect(std::string name)
: VideoTwoInputEffect(name) {
}

void VideoAlphaBlendEffect::BeforeDrawArrays(GLsizei width, GLsizei height, int program_index) {
    VideoTwoInputEffect::BeforeDrawArrays(width, height, program_index);
    
    GLint location = program_->UniformLocation(kVideoAlphaBlendEffectMixturePercent);
    auto uniform = uniforms_[std::string(kVideoAlphaBlendEffectMixturePercent)];
    glUniform1fv(location, 1, uniform.u_float.data());
}

}
}
}
