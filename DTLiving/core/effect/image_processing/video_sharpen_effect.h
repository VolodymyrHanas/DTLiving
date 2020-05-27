//
//  video_sharpen_effect.h
//  DTLiving
//
//  Created by Dan Jiang on 2020/5/26.
//  Copyright © 2020 Dan Thought Studio. All rights reserved.
//
//  音视频开发进阶指南：基于 Android 与 iOS 平台的实践 — 9.2.2 锐化效果器

#ifndef DTLIVING_EFFECT_IMAGE_PROCESSING_VIDEO_SHARPEN_EFFECT_H_
#define DTLIVING_EFFECT_IMAGE_PROCESSING_VIDEO_SHARPEN_EFFECT_H_

#include "video_effect.h"

namespace dtliving {
namespace effect {
namespace image_processing {

class VideoSharpenEffect: public VideoEffect {
public:
    VideoSharpenEffect(std::string name);

    virtual void LoadUniform();

protected:
    virtual void BeforeDrawArrays(GLsizei width, GLsizei height, int program_index);
    
private:
    GLint u_texelWidth_;
    GLint u_texelHeight_;
};

}
}
}

#endif /* video_sharpen_effect_h */

