//
//  video_brightness_effect.h
//  DTLiving
//
//  Created by Dan Jiang on 2020/3/19.
//  Copyright © 2020 Dan Thought Studio. All rights reserved.
//
//  https://en.wikipedia.org/wiki/Brightness
//
//  In an image, intensity of a pixel is defined as the value of the pixel. For example in an 8 bit grayscale image there are 256 gray levels. Now any pixel in an image can have a value from 0 to 255 and that will be its intensity
//
//  Now coming to brightness, as already answered brightness is a relative term. Suppose A, B and C are three pixels having intensities 1, 30 and 250, then C is brighter and A & B are darker with repsect to C. In general you can say the higher the intensity the brighter is the pixel.

#ifndef DTLIVING_EFFECT_COLOR_PROCESSING_VIDEO_BRIGHTNESS_EFFECT_H_
#define DTLIVING_EFFECT_COLOR_PROCESSING_VIDEO_BRIGHTNESS_EFFECT_H_

#include "video_effect.h"

namespace dtliving {
namespace effect {
namespace color_processing {

class VideoBrightnessEffect: public VideoEffect {
public:
    VideoBrightnessEffect(std::string name);

protected:
    void BeforeDrawArrays(GLsizei width, GLsizei height, int program_index);
};

}
}
}
#endif /* video_brightness_effect_h */
