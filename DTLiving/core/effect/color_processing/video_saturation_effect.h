//
//  video_saturation_effect.h
//  DTLiving
//
//  Created by Dan Jiang on 2020/4/7.
//  Copyright © 2020 Dan Thought Studio. All rights reserved.
//
//  In its definition, saturation is the purity of a color.
//  In short, adding shades of grey desaturates a color, while removing grey makes a color saturated.
//  https://photographylife.com/what-is-saturation-and-how-to-get-optimal-saturation
//
//  Luminance Weighting from "Graphics Shaders: Theory and Practice" by Bailey and Cunningham
//
//  音视频开发进阶指南：基于 Android 与 iOS 平台的实践 — 9.1.3 饱和度调节

#ifndef DTLIVING_EFFECT_COLOR_PROCESSING_VIDEO_SATURATION_EFFECT_H_
#define DTLIVING_EFFECT_COLOR_PROCESSING_VIDEO_SATURATION_EFFECT_H_

#include "video_effect.h"

namespace dtliving {
namespace effect {
namespace color_processing {

class VideoSaturationEffect: public VideoEffect {
public:
    VideoSaturationEffect(std::string name);

protected:
    virtual void BeforeDrawArrays(GLsizei width, GLsizei height, int program_index);
};

}
}
}

#endif /* video_saturation_effect_h */
