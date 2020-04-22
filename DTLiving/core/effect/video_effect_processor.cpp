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
#include "video_exposure_effect.h"
#include "video_contrast_effect.h"
#include "video_saturation_effect.h"
#include "video_gamma_effect.h"
#include "video_levels_effect.h"
#include "video_color_matrix_effect.h"
#include "video_rgb_effect.h"
#include "video_hue_effect.h"
#include "video_transform_effect.h"
#include "video_gaussian_blur_effect.h"
#include "video_box_blur_effect.h"

namespace dtliving {
namespace effect {

VideoEffectProcessor::VideoEffectProcessor() {
}

VideoEffectProcessor::~VideoEffectProcessor() {
}

void VideoEffectProcessor::Init(const char *vertex_shader_file, const char *fragment_shader_file) {
    no_effect_ = new VideoEffect("no_effect");
    no_effect_->LoadShaderFile(vertex_shader_file, fragment_shader_file);
}

void VideoEffectProcessor::AddEffect(const char *name, const char *vertex_shader_file, const char *fragment_shader_file) {
    VideoEffect *effect;
    bool isLoad = false;
    if (std::strcmp(name, kVideoBrightnessEffect) == 0) {
        effect = new color_processing::VideoBrightnessEffect(name);
    } else if (std::strcmp(name, kVideoExposureEffect) == 0) {
        effect = new color_processing::VideoExposureEffect(name);
    } else if (std::strcmp(name, kVideoContrastEffect) == 0) {
        effect = new color_processing::VideoContrastEffect(name);
    } else if (std::strcmp(name, kVideoSaturationEffect) == 0) {
        effect = new color_processing::VideoSaturationEffect(name);
    } else if (std::strcmp(name, kVideoGammaEffect) == 0) {
        effect = new color_processing::VideoGammaEffect(name);
    } else if (std::strcmp(name, kVideoLevelsEffect) == 0) {
        effect = new color_processing::VideoLevelsEffect(name);
    } else if (std::strcmp(name, kVideoColorMatrixEffect) == 0) {
        effect = new color_processing::VideoColorMatrixEffect(name);
    } else if (std::strcmp(name, kVideoRGBEffect) == 0) {
        effect = new color_processing::VideoRGBEffect(name);
    } else if (std::strcmp(name, kVideoHueEffect) == 0) {
        effect = new color_processing::VideoHueEffect(name);
    } else if (std::strcmp(name, kVideoTransformEffect) == 0) {
        effect = new image_processing::VideoTransformEffect(name);
    } else if (std::strcmp(name, kVideoGaussianBlurEffect) == 0) {
        auto blurEffect = new image_processing::VideoGaussianBlurEffect(name);
        blurEffect->LoadShaderSource();
        effect = blurEffect;
        isLoad = true;
    } else if (std::strcmp(name, kVideoBoxBlurEffect) == 0) {
        auto blurEffect = new image_processing::VideoBoxBlurEffect(name);
        blurEffect->LoadShaderSource();
        effect = blurEffect;
        isLoad = true;
    } else {
        effect = new VideoEffect(name);
    }
    if (!isLoad) {
        effect->LoadShaderFile(std::string(vertex_shader_file), std::string(fragment_shader_file));
    }
    effect->LoadUniform();
    effects_.push_back(effect);
}

void VideoEffectProcessor::SetClearColor(const char *name, GLfloat red, GLfloat green, GLfloat blue, GLfloat alpha) {
    for(VideoEffect *effect : effects_) {
        if (effect->get_name() == std::string(name)) {
            effect->set_clear_color(red, green, blue, alpha);
        }
    }
}

void VideoEffectProcessor::SetIgnoreAspectRatio(const char *name, bool ignore_aspect_ratio) {
    for(VideoEffect *effect : effects_) {
        if (effect->get_name() == std::string(name)) {
            effect->set_ignore_aspect_ratio(ignore_aspect_ratio);
        }
    }
}

void VideoEffectProcessor::SetPositions(const char *name, GLfloat *positions) {
    for(VideoEffect *effect : effects_) {
        if (effect->get_name() == std::string(name)) {
            effect->SetPositions(positions);
        }
    }
}

void VideoEffectProcessor::SetTextureCoordinates(const char *name, GLfloat *texture_coordinates) {
    for(VideoEffect *effect : effects_) {
        if (effect->get_name() == std::string(name)) {
            effect->SetTextureCoordinates(texture_coordinates);
        }
    }
}

void VideoEffectProcessor::SetEffectParamInt(const char *name, const char *param, GLint *value) {
    for(VideoEffect *effect : effects_) {
        if (effect->get_name() == std::string(name)) {
            VideoEffectUniform uniform;
            uniform.u_int = value;
            effect->SetUniform(param, uniform);
        }
    }
}

void VideoEffectProcessor::SetEffectParamFloat(const char *name, const char *param, GLfloat *value) {
    for(VideoEffect *effect : effects_) {
        if (effect->get_name() == std::string(name)) {
            VideoEffectUniform uniform;
            uniform.u_float = value;
            effect->SetUniform(param, uniform);
        }
    }
}

void VideoEffectProcessor::Process(VideoFrame input_frame, VideoFrame output_frame) {
    if (effects_.empty()) {
        no_effect_->Render(input_frame, output_frame);
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
            effect->Render(previous_frame, current_frame);
            previous_frame = current_frame;
            if (previous_texture != nullptr) {
                previous_texture->UnLock();
            }
            previous_texture = current_texture;
            count++;
        }
    }
}

}
}
