//
//  video_color_matrix_effect.cpp
//  DTLiving
//
//  Created by Dan Jiang on 2020/4/9.
//  Copyright © 2020 Dan Thought Studio. All rights reserved.
//

#include "constants.h"
#include "video_color_matrix_effect.h"

namespace dtliving {
namespace effect {
namespace color_processing {

VideoColorMatrixEffect::VideoColorMatrixEffect(std::string name)
: VideoEffect(name) {
}

void VideoColorMatrixEffect::BeforeDrawArrays(GLsizei width, GLsizei height, int program_index) {
    GLint location = program_->UniformLocation(kVideoColorMatrixEffectColorMatrix);
    auto uniform = uniforms_[std::string(kVideoColorMatrixEffectColorMatrix)];
    glUniformMatrix4fv(location, 1, false, uniform.u_float.data());
    
    location = program_->UniformLocation(kVideoColorMatrixEffectIntensity);
    uniform = uniforms_[std::string(kVideoColorMatrixEffectIntensity)];
    glUniform1fv(location, 1, uniform.u_float.data());
}

}
}
}
