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

void VideoAnimatedStickerEffect::Update() {
    auto uniform = uniforms_[std::string(kVideoAnimatedStickerEffectInterval)];
    double image_interval = double(uniform.u_float.front());
    double images_interval = image_frames_.size() * image_interval;
    double remind = std::fmod(time_since_first_update_, images_interval);
    image_index_ = remind / image_interval;
    // TODO: After That Walk From Start Position to End Position Repeatly
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

}
}
}
