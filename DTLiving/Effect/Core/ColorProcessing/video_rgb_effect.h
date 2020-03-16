//
//  video_rgb_effect.h
//  DTLiving
//
//  Created by Dan Jiang on 2020/3/16.
//  Copyright © 2020 Dan Thought Studio. All rights reserved.
//

#ifndef video_rgb_effect_h
#define video_rgb_effect_h

#include "video_effect.h"

class VideoRGBEffect: public VideoEffect {
    
public:
    void setRed(float red);
    void setGreen(float green);
    void setBlue(float blue);
};

#endif /* video_rgb_effect_h */
