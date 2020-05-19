//
//  video_transform_effect.cpp
//  DTLiving
//
//  Created by Dan Jiang on 2020/4/13.
//  Copyright © 2020 Dan Thought Studio. All rights reserved.
//

#include "video_transform_effect.h"

#include "constants.h"

namespace dtliving {
namespace effect {
namespace image_processing {

VideoTransformEffect::VideoTransformEffect(std::string name)
: VideoEffect(name) {
}

void VideoTransformEffect::LoadUniform() {
    VideoEffect::LoadUniform();
    
    u_orthographic_matrix_ = program_->UniformLocation("u_orthographicMatrix");
}

void VideoTransformEffect::BeforeSetPositions(GLsizei width, GLsizei height, int program_index) {
    // for right now, input frame size == output frame size == view port
    GLfloat normalized_height = GLfloat(height) / GLfloat(width);
    positions_[1] = -normalized_height;
    positions_[3] = -normalized_height;
    positions_[5] = normalized_height;
    positions_[7] = normalized_height;
}

void VideoTransformEffect::BeforeDrawArrays(GLsizei width, GLsizei height, int program_index) {
    auto matrix = VideoEffect::CaculateOrthographicMatrix(width, height);
    glUniformMatrix4fv(u_orthographic_matrix_, 1, false, matrix.data());

    GLint location = program_->UniformLocation(kVideoTransformEffectModelMatrix);
    auto uniform = uniforms_[std::string(kVideoTransformEffectModelMatrix)];
    glUniformMatrix4fv(location, 1, false, uniform.u_float.data());
}

}
}
}
