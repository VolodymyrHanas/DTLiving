//
//  video_texture.h
//  DTLiving
//
//  Created by Dan Jiang on 2020/3/18.
//  Copyright © 2020 Dan Thought Studio. All rights reserved.
//

#ifndef DTLIVING_EFFECT_VIDEO_TEXTURE_H_
#define DTLIVING_EFFECT_VIDEO_TEXTURE_H_

#include <OpenGLES/ES2/gl.h>
#include <OpenGLES/ES2/glext.h>

namespace dtliving {
namespace effect {

class VideoTexture {
public:
    VideoTexture(GLsizei width, GLsizei height);
    ~VideoTexture();
    
    GLsizei get_width();
    GLsizei get_height();
    GLuint get_texture_name();

    void Lock();
    void UnLock();
    void ClearLock();

private:
    GLsizei width_;
    GLsizei height_;
    int reference_count_;
    GLuint texture_name_;
};

}
}

#endif /* video_texture_h */
