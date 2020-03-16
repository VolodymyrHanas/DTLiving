//
//  video_effect_processor.cpp
//  DTLiving
//
//  Created by Dan Jiang on 2020/3/15.
//  Copyright © 2020 Dan Thought Studio. All rights reserved.
//

#include "video_effect_processor.h"

void VideoEffectProcessor::addEffect(const char *name) {
    if (name == VIDEO_BRIGHTNESS_EFFECT) {
        VideoBrightnessEffect *effect = new VideoBrightnessEffect();
        effects.push_back(effect);
    }
}

void VideoEffectProcessor::setEffectParamFloat(const char *name, const char *param, float value) {
}

void VideoEffectProcessor::render() {
    
}
