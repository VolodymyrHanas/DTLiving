//
//  video_transform_effect.cpp
//  DTLiving
//
//  Created by Dan Jiang on 2020/4/13.
//  Copyright © 2020 Dan Thought Studio. All rights reserved.
//

#include "constants.h"
#include "video_transform_effect.h"

namespace dtliving {
namespace effect {
namespace image_processing {

VideoTransformEffect::VideoTransformEffect(const char *name, const char *vertex_shader_file, const char *fragment_shader_file)
: VideoEffect(name, vertex_shader_file, fragment_shader_file) {
    set_is_orthographic(true);
}

void VideoTransformEffect::BeforeDrawArrays() {
    GLint location = program_->UniformLocation(kVideoTransformEffectTransformMatrix);
    auto uniform = uniforms_[std::string(kVideoTransformEffectTransformMatrix)];
    glUniformMatrix4fv(location, 1, false, uniform.u_float);
}

}
}
}
