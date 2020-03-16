//
//  video_brightness_effect.h
//  DTLiving
//
//  Created by Dan Jiang on 2020/3/16.
//  Copyright © 2020 Dan Thought Studio. All rights reserved.
//

#ifndef video_brightness_effect_h
#define video_brightness_effect_h

#include "video_effect.h"

#define VIDEO_BRIGHTNESS_EFFECT "VideoBrightnessEffect"

class VideoBrightnessEffect: public VideoEffect {
    
public:
    VideoBrightnessEffect();
    void setBrightness(float brightness);
};

#endif /* video_brightness_effect_h */
