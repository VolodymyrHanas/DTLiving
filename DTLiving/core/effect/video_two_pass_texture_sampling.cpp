//
//  video_two_pass_texture_sampling.cpp
//  DTLiving
//
//  Created by Dan Jiang on 2020/4/17.
//  Copyright © 2020 Dan Thought Studio. All rights reserved.
//

#include "video_two_pass_texture_sampling.h"

namespace dtliving {
namespace effect {

VideoTwoPassTextureSamplingEffect::VideoTwoPassTextureSamplingEffect(const char *name, const char *vertex_shader_file, const char *fragment_shader_file,
                                                                     const char *vertex_shader_file2, const char *fragment_shader_file2)
: VideoTwoPassEffect(name, vertex_shader_file, fragment_shader_file,
                     vertex_shader_file2, fragment_shader_file2) {
}

void VideoTwoPassTextureSamplingEffect::Init() {
    Init();
}

void VideoTwoPassTextureSamplingEffect::BeforeDrawArrays() {
}

}
}
