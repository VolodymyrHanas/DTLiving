//
//  video_rgb_effect.h
//  DTLiving
//
//  Created by Dan Jiang on 2020/3/19.
//  Copyright © 2020 Dan Thought Studio. All rights reserved.
//

#ifndef DTLIVING_EFFECT_COLOR_PROCESSING_VIDEO_RGB_EFFECT_H_
#define DTLIVING_EFFECT_COLOR_PROCESSING_VIDEO_RGB_EFFECT_H_

#include "video_effect.h"

namespace dtliving {
namespace effect {
namespace color_processing {

class VideoRGBEffect: public VideoEffect {
public:
    VideoRGBEffect(std::string name);

protected:
    virtual void BeforeDrawArrays(GLsizei width, GLsizei height, int program_index);
};

}
}
}

#endif /* video_rgb_effect_h */
