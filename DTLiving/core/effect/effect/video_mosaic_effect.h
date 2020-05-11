//
//  video_mosaic_effect.h
//  DTLiving
//
//  Created by Dan Jiang on 2020/5/11.
//  Copyright © 2020 Dan Thought Studio. All rights reserved.
//

#ifndef DTLIVING_EFFECT_EFFECT_VIDEO_MOSAIC_EFFECT_H_
#define DTLIVING_EFFECT_EFFECT_VIDEO_MOSAIC_EFFECT_H_

#include "video_two_input_effect.h"

namespace dtliving {
namespace effect {
namespace effect {

class VideoMosaicEffect: public VideoTwoInputEffect {
public:
    VideoMosaicEffect(std::string name);

protected:
    virtual void BeforeDrawArrays(GLsizei width, GLsizei height, int program_index);
};

}
}
}

#endif /* video_mosaic_effect_h */
