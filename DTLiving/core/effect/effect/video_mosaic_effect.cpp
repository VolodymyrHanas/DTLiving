//
//  video_mosaic_effect.cpp
//  DTLiving
//
//  Created by Dan Jiang on 2020/5/11.
//  Copyright © 2020 Dan Thought Studio. All rights reserved.
//

#include "video_mosaic_effect.h"

#include "constants.h"

namespace dtliving {
namespace effect {
namespace effect {

VideoMosaicEffect::VideoMosaicEffect(std::string name)
: VideoTwoInputEffect(name) {
}

void VideoMosaicEffect::BeforeDrawArrays(GLsizei width, GLsizei height, int program_index) {
    VideoTwoInputEffect::BeforeDrawArrays(width, height, program_index);
    
    GLint location = program_->UniformLocation(kVideoMosaicEffectInputTileSize);
    auto uniform = uniforms_[std::string(kVideoMosaicEffectInputTileSize)];
    glUniform2fv(location, 1, uniform.u_float.data());
    
    location = program_->UniformLocation(kVideoMosaicEffectDisplayTileSize);
    uniform = uniforms_[std::string(kVideoMosaicEffectDisplayTileSize)];
    glUniform2fv(location, 1, uniform.u_float.data());

    location = program_->UniformLocation(kVideoMosaicEffectNumTiles);
    uniform = uniforms_[std::string(kVideoMosaicEffectNumTiles)];
    glUniform1fv(location, 1, uniform.u_float.data());

    location = program_->UniformLocation(kVideoMosaicEffectColorOn);
    uniform = uniforms_[std::string(kVideoMosaicEffectColorOn)];
    glUniform1iv(location, 1, uniform.u_int.data());
}

}
}
}
