//
//  video_transform_effect.h
//  DTLiving
//
//  Created by Dan Jiang on 2020/4/13.
//  Copyright © 2020 Dan Thought Studio. All rights reserved.
//
//  Chapter 5 - Adjusting to the Screen’s Aspect Ratio - OpenGL ES 2 for Android

#ifndef DTLIVING_EFFECT_IMAGE_PROCESSING_VIDEO_TRANSFORM_EFFECT_H_
#define DTLIVING_EFFECT_IMAGE_PROCESSING_VIDEO_TRANSFORM_EFFECT_H_

#include "video_effect.h"

namespace dtliving {
namespace effect {
namespace image_processing {

class VideoTransformEffect: public VideoEffect {
public:
    VideoTransformEffect(std::string name);

protected:
    virtual void BeforeDrawArrays(GLsizei width, GLsizei height, int program_index);
};

}
}
}

#endif /* video_transform_effect_h */
