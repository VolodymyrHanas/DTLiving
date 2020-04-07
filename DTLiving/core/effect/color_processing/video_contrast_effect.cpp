//
//  video_contrast_effect.cpp
//  DTLiving
//
//  Created by Dan Jiang on 2020/4/7.
//  Copyright © 2020 Dan Thought Studio. All rights reserved.
//

#include "constants.h"
#include "video_contrast_effect.h"

namespace dtliving {
namespace effect {
namespace color_processing {

VideoContrastEffect::VideoContrastEffect(const char *name, const char *vertex_shader_file, const char *fragment_shader_file)
: VideoEffect(name, vertex_shader_file, fragment_shader_file) {
}

void VideoContrastEffect::BeforeDrawArrays() {
    GLint location = program_->UniformLocation(kVideoContrastEffectContrast);
    auto contrast = uniforms_[std::string(kVideoContrastEffectContrast)];
    glUniform1f(location, contrast.u_float);
}

}
}
}
