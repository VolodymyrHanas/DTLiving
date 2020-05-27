//
//  video_mask_effect.h
//  DTLiving
//
//  Created by Dan Jiang on 2020/5/9.
//  Copyright © 2020 Dan Thought Studio. All rights reserved.
//

#ifndef DTLIVING_EFFECT_BLEND_VIDEO_MASK_EFFECT_H_
#define DTLIVING_EFFECT_BLEND_VIDEO_MASK_EFFECT_H_

#include "video_two_input_effect.h"

namespace dtliving {
namespace effect {
namespace blend {

class VideoMaskEffect: public VideoTwoInputEffect {
public:
    VideoMaskEffect(std::string name);

protected:
    virtual void BeforeDrawArrays(GLsizei width, GLsizei height, int program_index);
};

}
}
}

#endif /* video_mask_effect_h */
