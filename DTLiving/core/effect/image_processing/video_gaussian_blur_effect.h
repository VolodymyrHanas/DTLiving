//
//  video_gaussian_blur_effect.h
//  DTLiving
//
//  Created by Dan Jiang on 2020/4/17.
//  Copyright © 2020 Dan Thought Studio. All rights reserved.
//
//  http://www.sunsetlakesoftware.com/2013/10/21/optimizing-gaussian-blurs-mobile-gpu
//  https://en.wikipedia.org/wiki/Gaussian_blur
//  https://github.com/mattdesl/lwjgl-basics/wiki/ShaderLesson5
//  音视频开发进阶指南：基于 Android 与 iOS 平台的实践 — 9.2.3 高斯模糊算法

#ifndef DTLIVING_EFFECT_IMAGE_PROCESSING_VIDEO_GAUSSIAN_BLUR_EFFECT_H_
#define DTLIVING_EFFECT_IMAGE_PROCESSING_VIDEO_GAUSSIAN_BLUR_EFFECT_H_

#include "video_two_pass_texture_sampling_effect.h"

namespace dtliving {
namespace effect {
namespace image_processing {

class VideoGaussianBlurEffect: public VideoTwoPassTextureSamplingEffect {
public:
    static std::string VertexShader(int blur_radius, float sigma);
    static std::string FragmentShader(int blur_radius, float sigma);

    VideoGaussianBlurEffect(std::string name);
    
    virtual void LoadShaderSource();

protected:
    virtual void BeforeDrawArrays(GLsizei width, GLsizei height, int program_index);

private:    
    GLfloat blur_radius_in_pixels_;
    int blur_radius_;
    float sigma_;
};

}
}
}

#endif /* video_gaussian_blur_effect_h */
