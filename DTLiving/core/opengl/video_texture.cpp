//
//  video_texture.cpp
//  DTLiving
//
//  Created by Dan Jiang on 2020/3/18.
//  Copyright © 2020 Dan Thought Studio. All rights reserved.
//

#include "video_texture.h"
#include "video_texture_cache.h"

namespace dtliving {
namespace opengl {

VideoTexture::VideoTexture(GLsizei width, GLsizei height)
: width_(width)
, height_(height)
, reference_count_(0) {
    glGenTextures(1, &texture_name_);
    glBindTexture(GL_TEXTURE_2D, texture_name_);
    
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);

    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, width_, height_, 0, GL_RGBA, GL_UNSIGNED_BYTE, 0);
    
    glBindTexture(GL_TEXTURE_2D, 0);
}

VideoTexture::~VideoTexture() {
    glDeleteTextures(1, &texture_name_);
}

GLsizei VideoTexture::get_width() {
    return width_;
}

GLsizei VideoTexture::get_height() {
    return height_;
}

GLuint VideoTexture::get_texture_name() {
    return texture_name_;
}

void VideoTexture::Lock() {
    reference_count_++;
}

void VideoTexture::UnLock() {
    reference_count_--;
    if (reference_count_ < 1) {
        VideoTextureCache::GetInstance()->ReturnTexture(this);
    }
}

void VideoTexture::ClearLock() {
    reference_count_ = 0;
}

}
}
