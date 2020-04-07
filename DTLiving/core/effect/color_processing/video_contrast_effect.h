//
//  video_contrast_effect.h
//  DTLiving
//
//  Created by Dan Jiang on 2020/4/7.
//  Copyright © 2020 Dan Thought Studio. All rights reserved.
//
//  When you increase contrast you are making the blacks darker and the whites brighter.
//  Decreasing the contrast does the opposite. If you look at the histogram you will see the base of the bell curve expand outward as contrast is increased and contract as contrast is decreased.
//
//  In an image, intensity of a pixel is defined as the value of the pixel. For example in an 8 bit grayscale image there are 256 gray levels. Now any pixel in an image can have a value from 0 to 255 and that will be its intensity
//
//  And there is another term called contrast. It is the difference between maximum and minimum pixel intensities in an image. Consider two images A having pixel intensities between 30 to 200 and B having pixel intensities 70 to 130. Then A has more contrast than B. Again contrast is also relative.

#ifndef DTLIVING_EFFECT_COLOR_PROCESSING_VIDEO_CONTRAST_EFFECT_H_
#define DTLIVING_EFFECT_COLOR_PROCESSING_VIDEO_CONTRAST_EFFECT_H_

#include "video_effect.h"

namespace dtliving {
namespace effect {
namespace color_processing {

class VideoContrastEffect: public VideoEffect {
public:
    VideoContrastEffect(const char *name, const char *vertex_shader_file, const char *fragment_shader_file);

    void BeforeDrawArrays();
};

}
}
}

#endif /* video_contrast_effect_h */
