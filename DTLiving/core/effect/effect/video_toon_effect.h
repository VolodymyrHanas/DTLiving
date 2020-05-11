//
//  video_toon_effect.h
//  DTLiving
//
//  Created by Dan Jiang on 2020/5/9.
//  Copyright © 2020 Dan Thought Studio. All rights reserved.
//
//  smooth toon: gaussian blur => toon

#ifndef DTLIVING_EFFECT_EFFECT_VIDEO_TOON_EFFECT_H_
#define DTLIVING_EFFECT_EFFECT_VIDEO_TOON_EFFECT_H_

#include "video_3x3_texture_sampling_effect.h"

namespace dtliving {
namespace effect {
namespace effect {

class VideoToonEffect: public Video3x3TextureSamplingEffect {
public:
    static std::string FragmentShader();

    VideoToonEffect(std::string name);

    virtual void LoadShaderSource();

protected:
    virtual void BeforeDrawArrays(GLsizei width, GLsizei height, int program_index);
};

}
}
}

#endif /* video_toon_effect_h */
