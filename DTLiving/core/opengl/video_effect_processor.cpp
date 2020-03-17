//
//  video_effect_processor.cpp
//  DTLiving
//
//  Created by Dan Jiang on 2020/3/15.
//  Copyright © 2020 Dan Thought Studio. All rights reserved.
//

#include "video_effect_processor.h"

namespace dtliving {
namespace opengl {

VideoEffectProcessor::VideoEffectProcessor() {
}

VideoEffectProcessor::~VideoEffectProcessor() {
}

void VideoEffectProcessor::AddEffect(const char *name, const char *vertex_shader_file, const char *fragment_shader_file) {
    VideoEffect *effect = new VideoEffect(name, vertex_shader_file, fragment_shader_file);
    effects_.push_back(effect);
}

void VideoEffectProcessor::SetEffectParamFloat(const char *name, const char *param, GLfloat value) {
    for(VideoEffect *effect : effects_) {
        if (effect->get_name() == name) {
            effect->SetUniformFloat(param, value);
        }
    }
}

void VideoEffectProcessor::Render() {
    for(VideoEffect *effect : effects_) {
//        effect->Render()
    }
}

}
}
