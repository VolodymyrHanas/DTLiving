//
//  video_two_input_effect.cpp
//  DTLiving
//
//  Created by Dan Jiang on 2020/4/27.
//  Copyright © 2020 Dan Thought Studio. All rights reserved.
//

#include "video_two_input_effect.h"

namespace dtliving {
namespace effect {

VideoTwoInputEffect::VideoTwoInputEffect(std::string name)
: VideoEffect(name) {
}

void VideoTwoInputEffect::LoadUniform() {
    VideoEffect::LoadUniform();
        
    a_texcoord2_ = program_->AttributeLocation("a_texcoord2");
    u_texture2_ = program_->UniformLocation("u_texture2");
}

void VideoTwoInputEffect::LoadResources(std::vector<std::string> resources) {
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
    
    png_decoder_->DeleteImage();
}

void VideoTwoInputEffect::BeforeDrawArrays(GLsizei width, GLsizei height, int program_index) {
    glActiveTexture(GL_TEXTURE1);
    glBindTexture(GL_TEXTURE_2D, input_frame2_.texture_name);
    glUniform1i(u_texture2_, 1);
    
    std::vector<GLfloat> texture_coordinates = { 0, 0, 1, 0, 0, 1, 1, 1 };
    
    glEnableVertexAttribArray(a_texcoord2_);
    glVertexAttribPointer(a_texcoord2_,
                          2,
                          GL_FLOAT,
                          GL_FALSE,
                          0,
                          texture_coordinates.data()); // TODO: caculate texture coordinates
}

}
}
