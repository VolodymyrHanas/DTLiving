//
//  video_effect_processor.h
//  DTLiving
//
//  Created by Dan Jiang on 2020/3/15.
//  Copyright © 2020 Dan Thought Studio. All rights reserved.
//

#ifndef video_effect_processor_h
#define video_effect_processor_h

#include <vector>
#include "video_effect.h"
#include "video_brightness_effect.h"

class VideoEffectProcessor {
private:
    std::vector<VideoEffect *> effects;
    
public:
    void addEffect(const char *name);
    void setEffectParamFloat(const char *name, const char *param, float value);
    void render();
    // TODO: switch effect
};

#endif /* video_effect_processor_h */
