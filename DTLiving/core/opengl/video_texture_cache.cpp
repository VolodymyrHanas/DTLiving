//
//  video_texture_cache.cpp
//  DTLiving
//
//  Created by Dan Jiang on 2020/3/18.
//  Copyright © 2020 Dan Thought Studio. All rights reserved.
//

#include "video_texture_cache.h"
#include <sstream>

namespace dtliving {
namespace opengl {

VideoTextureCache::VideoTextureCache() {
}

VideoTextureCache::~VideoTextureCache() {
    for (auto it = texture_cache_.begin(); it != texture_cache_.end(); ++it) {
        it->second.clear();
    }
    texture_cache_.clear();
}

VideoTextureCache* VideoTextureCache::instance_ = new VideoTextureCache();
VideoTextureCache* VideoTextureCache::GetInstance() {
    return instance_;
}

VideoTexture* VideoTextureCache::FetchTexture(GLsizei width, GLsizei height) {
    VideoTexture *texture = nullptr;
    std::string key = Hash(width, height);
    auto search = texture_cache_.find(key);
    if (search != texture_cache_.end()) {
        if (search->second.size() > 0) {
            texture = search->second.front();
            search->second.pop_front();
        } else {
            texture = new VideoTexture(width, height);
        }
    } else {
        std::list<VideoTexture *> textures {};
        texture = new VideoTexture(width, height);
        texture_cache_[key] = textures;
    }
    return texture;
}

void VideoTextureCache::ReturnTexture(VideoTexture *texture) {
    std::string key = Hash(texture->get_width(), texture->get_height());
    auto search = texture_cache_.find(key);
    if (search != texture_cache_.end()) {
        search->second.push_back(texture);
    }
}

std::string VideoTextureCache::Hash(GLsizei width, GLsizei height) {
    std::stringstream ss;
    ss << "texture_";
    ss << width;
    ss << "_";
    ss << height;
    return ss.str();
}

}
}
