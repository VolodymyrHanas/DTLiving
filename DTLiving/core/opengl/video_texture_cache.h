//
//  video_texture_cache.h
//  DTLiving
//
//  Created by Dan Jiang on 2020/3/18.
//  Copyright © 2020 Dan Thought Studio. All rights reserved.
//

#ifndef DTLIVING_OPENGL_VIDEO_TEXTURE_CACHE_H_
#define DTLIVING_OPENGL_VIDEO_TEXTURE_CACHE_H_

#include "video_texture.h"
#include <map>
#include <list>
#include <string>

namespace dtliving {
namespace opengl {

class VideoTextureCache {
public:
    static VideoTextureCache* GetInstance();
    ~VideoTextureCache();
    
    VideoTexture* FetchTexture(GLsizei width, GLsizei height);
    void ReturnTexture(VideoTexture *texture);

private:
    VideoTextureCache();
    
    static VideoTextureCache *instance_;
    
    std::string Hash(GLsizei width, GLsizei height);
    
    std::map<std::string, std::list<VideoTexture *>> texture_cache_;
};

}
}

#endif /* video_texture_cache_h */
