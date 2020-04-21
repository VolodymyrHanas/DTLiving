//
//  video_exposure_effect.h
//  DTLiving
//
//  Created by Dan Jiang on 2020/4/7.
//  Copyright © 2020 Dan Thought Studio. All rights reserved.
//
//  https://www.objc.io/issues/21-camera-and-photos/how-your-camera-works/#quantities-of-light

#ifndef DTLIVING_EFFECT_COLOR_PROCESSING_VIDEO_EXPOSURE_EFFECT_H_
#define DTLIVING_EFFECT_COLOR_PROCESSING_VIDEO_EXPOSURE_EFFECT_H_

#include "video_effect.h"

namespace dtliving {
namespace effect {
namespace color_processing {

class VideoExposureEffect: public VideoEffect {
public:
    VideoExposureEffect(std::string name);

protected:
    void BeforeDrawArrays(GLsizei width, GLsizei height, int program_index);
};

}
}
}

#endif /* video_exposure_effect_h */
