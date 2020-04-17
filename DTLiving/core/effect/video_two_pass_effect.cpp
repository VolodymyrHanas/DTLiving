//
//  video_two_pass_effect.cpp
//  DTLiving
//
//  Created by Dan Jiang on 2020/4/15.
//  Copyright © 2020 Dan Thought Studio. All rights reserved.
//

#include "video_two_pass_effect.h"

namespace dtliving {
namespace effect {

VideoTwoPassEffect::VideoTwoPassEffect(const char *name, const char *vertex_shader_file, const char *fragment_shader_file,
                                       const char *vertex_shader_file2, const char *fragment_shader_file2)
: VideoEffect(name, vertex_shader_file, fragment_shader_file)
, vertex_shader_file2_(vertex_shader_file2)
, fragment_shader_file2_(fragment_shader_file2) {
}

void VideoTwoPassEffect::Init() {
    Init();
    
    program2_ = new ShaderProgram(vertex_shader_file2_, fragment_shader_file2_);
    
    a_position2_ = program_->AttributeLocation("a_position");
    a_texcoord2_ = program_->AttributeLocation("a_texcoord");
}

void VideoTwoPassEffect::BeforeDrawArrays() {
}

}
}
