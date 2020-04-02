//
//  video_frame.h
//  DTLiving
//
//  Created by Dan Jiang on 2020/3/19.
//  Copyright © 2020 Dan Thought Studio. All rights reserved.
//

#ifndef DTLIVING_EFFECT_VIDEO_FRAME_H_
#define DTLIVING_EFFECT_VIDEO_FRAME_H_

#include <OpenGLES/ES2/gl.h>
#include <OpenGLES/ES2/glext.h>

namespace dtliving {
namespace effect {

struct VideoFrame {
    GLuint texture_name;
    GLsizei width;
    GLsizei height;
};

}
}

#endif /* video_frame_h */
