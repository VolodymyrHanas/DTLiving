//
//  video_text_effect.cpp
//  DTLiving
//
//  Created by Dan Jiang on 2020/5/22.
//  Copyright © 2020 Dan Thought Studio. All rights reserved.
//

#include "video_text_effect.h"

#include "constants.h"

namespace dtliving {
namespace effect {
namespace composition {

VideoTextEffect::VideoTextEffect(std::string name)
: VideoCompositionEffect(name) {
}

void VideoTextEffect::SetTextures(std::vector<VideoFrame> textures) {
    image_frame_ = textures.front();
}

void VideoTextEffect::BeforeSetPositions(GLsizei width, GLsizei height, int program_index) {
    if (program_index == 1) {
        glActiveTexture(GL_TEXTURE0);
        glBindTexture(GL_TEXTURE_2D, image_frame_.texture_name);
        glUniform1i(u_texture2_, 0);
        
        // layout image frame`s center at origin
        GLfloat normalized_width = GLfloat(image_frame_.width) / GLfloat(width);
        GLfloat normalized_height = GLfloat(image_frame_.height) / GLfloat(width);
        positions2_[0] = -normalized_width;
        positions2_[1] = -normalized_height;
        positions2_[2] = normalized_width;
        positions2_[3] = -normalized_height;
        positions2_[4] = -normalized_width;
        positions2_[5] = normalized_height;
        positions2_[6] = normalized_width;
        positions2_[7] = normalized_height;
    }
}

void VideoTextEffect::BeforeDrawArrays(GLsizei width, GLsizei height, int program_index) {
    VideoCompositionEffect::BeforeDrawArrays(width, height, program_index);
    if (program_index == 1) {
        GLint location = program2_->UniformLocation(kVideoCompositionEffectModelMatrix);
        auto uniform = uniforms_[std::string(kVideoCompositionEffectModelMatrix)];
        glUniformMatrix4fv(location, 1, false, uniform.u_float.data());
    }
}

}
}
}
