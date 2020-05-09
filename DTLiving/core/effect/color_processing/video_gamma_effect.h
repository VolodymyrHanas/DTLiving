//
//  video_gamma_effect.h
//  DTLiving
//
//  Created by Dan Jiang on 2020/4/7.
//  Copyright © 2020 Dan Thought Studio. All rights reserved.
//
//  Gamma is about translating between digital sensitivity and human eye sensitivity, providing many advantages on one hand but adding complexity on the other hand.
//  Gamma adjusts the midtones from tonal scale but keeps the white and black.
//  In other words, gamma optimizes the contrast and brightness in the midtones.
//  https://www.orpalis.com/blog/color-adjustments-brightness-contrast-and-gamma-2/

#ifndef DTLIVING_EFFECT_COLOR_PROCESSING_VIDEO_GAMMA_EFFECT_H_
#define DTLIVING_EFFECT_COLOR_PROCESSING_VIDEO_GAMMA_EFFECT_H_

#include "video_effect.h"

namespace dtliving {
namespace effect {
namespace color_processing {

class VideoGammaEffect: public VideoEffect {
public:
    VideoGammaEffect(std::string name);

protected:
    virtual void BeforeDrawArrays(GLsizei width, GLsizei height, int program_index);
};

}
}
}

#endif /* video_gamma_effect_h */
