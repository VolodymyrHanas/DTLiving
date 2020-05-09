//
//  video_levels_effect.h
//  DTLiving
//
//  Created by Dan Jiang on 2020/4/8.
//  Copyright © 2020 Dan Thought Studio. All rights reserved.
//
//  Photoshop-like levels adjustment. The min, max, minOut and maxOut parameters are floats in the range [0, 1]. If you have parameters from Photoshop in the range [0, 255] you must first convert them to be [0, 1]. The gamma/mid parameter is a float >= 0. This matches the value from Photoshop. If you want to apply levels to RGB as well as individual channels you need to use this filter twice - first for the individual channels and then for all channels.

#ifndef DTLIVING_EFFECT_COLOR_PROCESSING_VIDEO_LEVELS_EFFECT_H_
#define DTLIVING_EFFECT_COLOR_PROCESSING_VIDEO_LEVELS_EFFECT_H_

#include "video_effect.h"

namespace dtliving {
namespace effect {
namespace color_processing {

class VideoLevelsEffect: public VideoEffect {
public:
    VideoLevelsEffect(std::string name);

protected:
    virtual void BeforeDrawArrays(GLsizei width, GLsizei height, int program_index);
};

}
}
}

#endif /* video_levels_effect_h */
