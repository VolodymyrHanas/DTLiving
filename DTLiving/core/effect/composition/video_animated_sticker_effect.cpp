//
//  video_animated_sticker_effect.cpp
//  DTLiving
//
//  Created by Dan Jiang on 2020/5/19.
//  Copyright © 2020 Dan Thought Studio. All rights reserved.
//

#include "video_animated_sticker_effect.h"

#include <cmath>
#include <iostream>

#include "constants.h"

namespace dtliving {
namespace effect {
namespace composition {

VideoAnimatedStickerEffect::VideoAnimatedStickerEffect(std::string name)
: VideoCompositionEffect(name) {
}

void VideoAnimatedStickerEffect::LoadResources(std::vector<std::string> resources) {
    for (auto file : resources) {
        decoder::image::RawImageData image_data = png_decoder_->ReadImage(file);
        
        VideoFrame input_frame;
        input_frame.width = image_data.width;
        input_frame.height = image_data.height;

        glGenTextures(1, &input_frame.texture_name);
        glBindTexture(GL_TEXTURE_2D, input_frame.texture_name);
        
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
        
        glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, image_data.width, image_data.height, 0, GL_RGBA, GL_UNSIGNED_BYTE, image_data.data);
        
        glBindTexture(GL_TEXTURE_2D, 0);
        
        image_frames_.push_back(input_frame);
    }
}

void VideoAnimatedStickerEffect::Update(GLsizei width, GLsizei height) {
    float time = float(time_since_first_update_);
    
    auto uniform = uniforms_[std::string(kVideoAnimatedStickerEffectImageInterval)];
    float image_interval = uniform.u_float.front();
    float images_interval = image_frames_.size() * image_interval;
    float remind = std::fmod(time, images_interval);
    image_index_ = remind / image_interval;
    
    // just linear interpolation
    uniform = uniforms_[std::string(kVideoAnimatedStickerEffectAnimateDuration)];
    float animate_duration = uniform.u_float.front();
    remind = std::fmod(time, animate_duration);
    float progress = remind / animate_duration;
    
    uniform = uniforms_[std::string(kVideoAnimatedStickerEffectStartScale)];
    float start_scale = uniform.u_float.front();
    uniform = uniforms_[std::string(kVideoAnimatedStickerEffectEndScale)];
    float end_scale = uniform.u_float.front();
    uniform = uniforms_[std::string(kVideoAnimatedStickerEffectStartRotate)];
    float start_rotate = uniform.u_float.front();
    uniform = uniforms_[std::string(kVideoAnimatedStickerEffectEndRotate)];
    float end_rotate = uniform.u_float.front();
    uniform = uniforms_[std::string(kVideoAnimatedStickerEffectStartTranslate)];
    vec2 start_translate = vec2(uniform.u_float.data()) / float(width / 2);
    uniform = uniforms_[std::string(kVideoAnimatedStickerEffectEndTranslate)];
    vec2 end_translate = vec2(uniform.u_float.data()) / float(width / 2);

    mat4 matrix = mat4::Identity();
    auto scale = start_scale + (end_scale - start_scale) * progress;
    matrix = matrix * mat4::Scale(scale);
    auto rotate = start_rotate + (end_rotate - start_rotate) * progress;
    matrix = matrix * mat4::Rotate(rotate);
    auto translate = start_translate + (end_translate - start_translate) * progress;
    matrix = matrix * mat4::Translate(translate.x, translate.y, 0.0);
    
    model_matrix_ = matrix;
}

void VideoAnimatedStickerEffect::BeforeSetPositions(GLsizei width, GLsizei height, int program_index) {
    if (program_index == 1) {
        auto image_frame = image_frames_[image_index_];
        
        glActiveTexture(GL_TEXTURE0);
        glBindTexture(GL_TEXTURE_2D, image_frame.texture_name);
        glUniform1i(u_texture2_, 0);
                
        // layout image frame`s center at origin
        GLfloat normalized_width = GLfloat(image_frame.width) / GLfloat(width);
        GLfloat normalized_height = GLfloat(image_frame.height) / GLfloat(width);
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

void VideoAnimatedStickerEffect::BeforeDrawArrays(GLsizei width, GLsizei height, int program_index) {
    VideoCompositionEffect::BeforeDrawArrays(width, height, program_index);
    if (program_index == 1) {
        GLint location = program2_->UniformLocation(kVideoCompositionEffectModelMatrix);
        glUniformMatrix4fv(location, 1, false, model_matrix_.Pointer());
    }
}

}
}
}
