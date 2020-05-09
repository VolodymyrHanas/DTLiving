//
//  video_alpha_blend_effect.h
//  DTLiving
//
//  Created by Dan Jiang on 2020/5/9.
//  Copyright © 2020 Dan Thought Studio. All rights reserved.
//

#ifndef DTLIVING_EFFECT_BLEND_ALPHA_BLEND_EFFECT_H_
#define DTLIVING_EFFECT_BLEND_ALPHA_BLEND_EFFECT_H_

#include "video_two_input_effect.h"

namespace dtliving {
namespace effect {
namespace blend {

class VideoAlphaBlendEffect: public VideoTwoInputEffect {
public:
    VideoAlphaBlendEffect(std::string name);

protected:
    virtual void BeforeDrawArrays(GLsizei width, GLsizei height, int program_index);
};

}
}
}

#endif /* video_alpha_blend_effect_h */
