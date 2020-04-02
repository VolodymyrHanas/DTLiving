//
//  video_effect_uniform.h
//  DTLiving
//
//  Created by Dan Jiang on 2020/3/19.
//  Copyright © 2020 Dan Thought Studio. All rights reserved.
//

#ifndef DTLIVING_EFFECT_VIDEO_EFFECT_UNIFORMS_H_
#define DTLIVING_EFFECT_VIDEO_EFFECT_UNIFORMS_H_

#include <OpenGLES/ES2/gl.h>
#include <OpenGLES/ES2/glext.h>

namespace dtliving {
namespace effect {

struct VideoEffectUniform {
    GLfloat u_float;
};

}
}

#endif /* video_effect_uniform_h */
