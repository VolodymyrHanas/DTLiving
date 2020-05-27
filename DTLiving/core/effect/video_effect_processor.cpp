//
//  video_effect_processor.cpp
//  DTLiving
//
//  Created by Dan Jiang on 2020/3/15.
//  Copyright © 2020 Dan Thought Studio. All rights reserved.
//

#include "video_effect_processor.h"

#include <cstring>

#include "constants.h"
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
#include "video_sobel_edge_detection_effect.h"
#include "video_two_input_effect.h"
#include "video_alpha_blend_effect.h"
#include "video_mask_effect.h"
#include "video_3x3_convolution_effect.h"
#include "video_toon_effect.h"
#include "video_sketch_effect.h"
#include "video_mosaic_effect.h"
#include "video_water_mask_effect.h"
#include "video_animated_sticker_effect.h"
#include "video_text_effect.h"
#include "video_sharpen_effect.h"
#include "video_bilateral_effect.h"

namespace dtliving {
namespace effect {

VideoEffectProcessor::VideoEffectProcessor() {
}

VideoEffectProcessor::~VideoEffectProcessor() {
}

void VideoEffectProcessor::Init(const char *vertex_shader_file, const char *fragment_shader_file) {
    no_effect_ = new VideoEffect("no_effect");
    no_effect_->LoadShaderFile(vertex_shader_file, fragment_shader_file);
    no_effect_->LoadUniform();
}

void VideoEffectProcessor::AddEffect(const char *name, const char *vertex_shader_file, const char *fragment_shader_file) {
    VideoEffect *effect;
    bool isShaderFile = true;
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
        effect = new image_processing::VideoGaussianBlurEffect(name);
        isShaderFile = false;
    } else if (std::strcmp(name, kVideoBoxBlurEffect) == 0) {
        effect = new image_processing::VideoBoxBlurEffect(name);
        isShaderFile = false;
    } else if (std::strcmp(name, kVideoSobelEdgeDetectionEffect) == 0) {
        effect = new image_processing::VideoSobelEdgeDetectionEffect(name);
        isShaderFile = false;
    } else if (std::strcmp(name, kVideoAddBlendEffect) == 0) {
        effect = new VideoTwoInputEffect(name);
    } else if (std::strcmp(name, kVideoAlphaBlendEffect) == 0) {
        effect = new blend::VideoAlphaBlendEffect(name);
    } else if (std::strcmp(name, kVideoMaskEffect) == 0) {
        effect = new blend::VideoMaskEffect(name);
    } else if (std::strcmp(name, kVideoEmbossEffect) == 0) {
        effect = new Video3x3ConvolutionEffect(name);
        isShaderFile = false;
    } else if (std::strcmp(name, kVideoToonEffect) == 0) {
        effect = new effect::VideoToonEffect(name);
        isShaderFile = false;
    } else if (std::strcmp(name, kVideoSketchEffect) == 0) {
        effect = new effect::VideoSketchEffect(name);
        isShaderFile = false;
    } else if (std::strcmp(name, kVideoMosaicEffect) == 0) {
        effect = new effect::VideoMosaicEffect(name);
    } else if (std::strcmp(name, kVideoWaterMaskEffect) == 0) {
        effect = new composition::VideoWaterMaskEffect(name);
        isShaderFile = false;
    } else if (std::strcmp(name, kVideoAnimatedStickerEffect) == 0) {
        effect = new composition::VideoAnimatedStickerEffect(name);
        isShaderFile = false;
    } else if (std::strcmp(name, kVideoTextEffect) == 0) {
        effect = new composition::VideoTextEffect(name);
        isShaderFile = false;
    } else if (std::strcmp(name, kVideoSharpenEffect) == 0) {
        effect = new image_processing::VideoSharpenEffect(name);
    } else if (std::strcmp(name, kVideoBilateralEffect) == 0) {
        effect = new image_processing::VideoBilateralEffect(name);
    } else {
        effect = new VideoEffect(name);
    }
    if (isShaderFile) {
        effect->LoadShaderFile(std::string(vertex_shader_file), std::string(fragment_shader_file));
    } else {
        effect->LoadShaderSource();
    }
    effect->LoadUniform();
    effects_.push_back(effect);
}

void VideoEffectProcessor::SetDuration(const char *name, double duration) {
    for(VideoEffect *effect : effects_) {
        if (effect->get_name() == std::string(name)) {
            effect->set_duration(duration);
        }
    }
}

void VideoEffectProcessor::SetClearColor(const char *name, vec4 clear_color) {
    for(VideoEffect *effect : effects_) {
        if (effect->get_name() == std::string(name)) {
            effect->set_clear_color(clear_color);
        }
    }
}

void VideoEffectProcessor::LoadResources(const char *name, std::vector<std::string> resources) {
    for(VideoEffect *effect : effects_) {
        if (effect->get_name() == std::string(name)) {
            effect->LoadResources(resources);
        }
    }
}

void VideoEffectProcessor::SetTextures(const char *name, std::vector<VideoFrame> textures) {
    for(VideoEffect *effect : effects_) {
        if (effect->get_name() == std::string(name)) {
            effect->SetTextures(textures);
        }
    }
}

void VideoEffectProcessor::SetPositions(const char *name, GLfloat *positions) {
    for(VideoEffect *effect : effects_) {
        if (effect->get_name() == std::string(name)) {
            effect->SetPositions(std::vector<GLfloat>(positions, positions + 8));
        }
    }
}

void VideoEffectProcessor::SetTextureCoordinates(const char *name, GLfloat *texture_coordinates) {
    for(VideoEffect *effect : effects_) {
        if (effect->get_name() == std::string(name)) {
            effect->SetTextureCoordinates(std::vector<GLfloat>(texture_coordinates, texture_coordinates + 8));
        }
    }
}

void VideoEffectProcessor::SetEffectParamInt(const char *name, const char *param, GLint *value, int size) {
    for(VideoEffect *effect : effects_) {
        if (effect->get_name() == std::string(name)) {
            VideoEffectUniform uniform;
            uniform.u_int = std::vector<GLint>(value, value + size);
            effect->SetUniform(std::string(param), uniform);
        }
    }
}

void VideoEffectProcessor::SetEffectParamFloat(const char *name, const char *param, GLfloat *value, int size) {
    for(VideoEffect *effect : effects_) {
        if (effect->get_name() == std::string(name)) {
            VideoEffectUniform uniform;
            uniform.u_float = std::vector<GLfloat>(value, value + size);
            effect->SetUniform(std::string(param), uniform);
        }
    }
}

void VideoEffectProcessor::Process(VideoFrame input_frame, VideoFrame output_frame, double delta) {
    if (effects_.empty()) {
        no_effect_->Render(input_frame, output_frame);
    } else {
        int count = 0;
        VideoFrame previous_frame = input_frame;
        VideoFrame current_frame;
        VideoTexture *previous_texture = nullptr;
        std::vector<VideoEffect *> available_effects;
        for(VideoEffect *effect : effects_) {
            if (effect->Update(delta, output_frame.width, output_frame.height)) {
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
                available_effects.push_back(effect);
            }
        }
        if (previous_texture != nullptr) {
            previous_texture->UnLock();
        }
        if (available_effects.empty()) {
            no_effect_->Render(input_frame, output_frame);
        }
        effects_ = available_effects;
    }
}

}
}
