//
//  video_effect_processor.cpp
//  DTLiving
//
//  Created by Dan Jiang on 2020/3/15.
//  Copyright © 2020 Dan Thought Studio. All rights reserved.
//

#include <cstring>

#include "constants.h"
#include "video_effect_processor.h"
#include "video_texture_cache.h"
#include "video_brightness_effect.h"
#include "video_rgb_effect.h"

namespace dtliving {
namespace opengl {

VideoEffectProcessor::VideoEffectProcessor() {
}

VideoEffectProcessor::~VideoEffectProcessor() {
}

void VideoEffectProcessor::Init() {
    glGenFramebuffers(1, &frame_buffer_);
}

void VideoEffectProcessor::AddEffect(const char *name, const char *vertex_shader_file, const char *fragment_shader_file) {
    VideoEffect *effect;
    if (std::strcmp(name, kVideoBrightnessEffect) == 0) {
        effect = new color_processing::VideoBrightnessEffect(name, vertex_shader_file, fragment_shader_file);
    } else if (std::strcmp(name, kVideoRGBEffect) == 0) {
        effect = new color_processing::VideoRGBEffect(name, vertex_shader_file, fragment_shader_file);
    } else {
        effect = new VideoEffect(name, vertex_shader_file, fragment_shader_file);
    }
    effect->Init();
    effects_.push_back(effect);
}

void VideoEffectProcessor::SetEffectParamFloat(const char *name, const char *param, GLfloat value) {
    for(VideoEffect *effect : effects_) {
        if (effect->get_name() == name) {
            VideoEffectUniform uniform;
            uniform.u_float = value;
            effect->SetUniform(name, uniform);
        }
    }
}

void VideoEffectProcessor::Process(VideoFrame input_frame, VideoFrame output_frame) {
    if (effects_.empty()) {
        // TODO: Direct Pass
    } else {
        int count = 0;
        VideoFrame previous_frame = input_frame;
        VideoFrame current_frame;
        VideoTexture *previous_texture = nullptr;
        for(VideoEffect *effect : effects_) {
            current_frame = output_frame;
            VideoTexture *current_texture = nullptr;
            if (count < effects_.size() - 1) {
                current_texture = VideoTextureCache::GetInstance()->FetchTexture(input_frame.width,
                                                                                 input_frame.height);
                current_texture->Lock();
                current_frame = {
                    current_texture->get_texture_name(),
                    current_texture->get_width(),
                    current_texture->get_height()
                };
            }
            glFramebufferTexture2D(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_TEXTURE_2D, current_frame.texture_name, 0);
            effect->Render(previous_frame, current_frame);
            previous_frame = current_frame;
            if (previous_texture != nullptr) {
                previous_texture->Lock();
            }
            previous_texture = current_texture;
            count++;
        }
    }
}

}
}
