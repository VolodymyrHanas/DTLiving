//
//  video_water_mask_effect.cpp
//  DTLiving
//
//  Created by Dan Jiang on 2020/5/18.
//  Copyright © 2020 Dan Thought Studio. All rights reserved.
//

#include "video_water_mask_effect.h"

#include "constants.h"

namespace dtliving {
namespace effect {
namespace composition {

VideoWaterMaskEffect::VideoWaterMaskEffect(std::string name)
: VideoCompositionEffect(name) {
}

void VideoWaterMaskEffect::LoadResources(std::vector<std::string> resources) {
    std::string file = resources.front();
    
    decoder::image::RawImageData image_data = png_decoder_->ReadImage(file);
    
    input_frame2_.width = image_data.width;
    input_frame2_.height = image_data.height;

    glGenTextures(1, &input_frame2_.texture_name);
    glBindTexture(GL_TEXTURE_2D, input_frame2_.texture_name);
    
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
    
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, image_data.width, image_data.height, 0, GL_RGBA, GL_UNSIGNED_BYTE, image_data.data);
    
    glBindTexture(GL_TEXTURE_2D, 0);
}

void VideoWaterMaskEffect::BeforeSetPositions(GLsizei width, GLsizei height, int program_index) {
    if (program_index == 1) {
        glActiveTexture(GL_TEXTURE0);
        glBindTexture(GL_TEXTURE_2D, input_frame2_.texture_name);
        glUniform1i(u_texture2_, 0);
        
        // layout image frame`s center at origin
        GLfloat normalized_width = GLfloat(input_frame2_.width) / GLfloat(width);
        GLfloat normalized_height = GLfloat(input_frame2_.height) / GLfloat(width);
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
