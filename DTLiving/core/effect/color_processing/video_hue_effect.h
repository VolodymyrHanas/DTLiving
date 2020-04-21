//
//  video_hue_effect.h
//  DTLiving
//
//  Created by Dan Jiang on 2020/4/10.
//  Copyright © 2020 Dan Thought Studio. All rights reserved.
//
//  A HUE refers to the dominant Color Family of the specific color we're looking at. White, Black and Grey are never referred to as a Hue.
//  https://color-wheel-artist.com/hue/
//  http://stackoverflow.com/questions/9234724/how-to-change-hue-of-a-texture-with-glsl
//  https://en.wikipedia.org/wiki/YIQ

#ifndef DTLIVING_EFFECT_COLOR_PROCESSING_VIDEO_HUE_EFFECT_H_
#define DTLIVING_EFFECT_COLOR_PROCESSING_VIDEO_HUE_EFFECT_H_

#include "video_effect.h"

namespace dtliving {
namespace effect {
namespace color_processing {

class VideoHueEffect: public VideoEffect {
public:
    VideoHueEffect(std::string name);

protected:
    void BeforeDrawArrays(GLsizei width, GLsizei height, int program_index);
};

}
}
}

#endif /* video_hue_effect_h */
