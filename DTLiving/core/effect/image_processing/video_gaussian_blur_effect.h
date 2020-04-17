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

#ifndef DTLIVING_EFFECT_IMAGE_PROCESSING_VIDEO_GAUSSIAN_BLUR_EFFECT_H_
#define DTLIVING_EFFECT_IMAGE_PROCESSING_VIDEO_GAUSSIAN_BLUR_EFFECT_H_

#include "video_two_pass_texture_sampling.h"

namespace dtliving {
namespace effect {
namespace image_processing {

class VideoGaussianBlurEffect: public VideoTwoPassTextureSamplingEffect {
public:
    VideoGaussianBlurEffect(const char *name, const char *vertex_shader_file, const char *fragment_shader_file,
                            const char *vertex_shader_file2, const char *fragment_shader_file2);

    virtual void Init();
    
protected:
    virtual void BeforeDrawArrays();

private:
    static std::string VertexShaderOptimized(int blur_radius, float sigma);
    static std::string FragmentShaderOptimized(int blur_radius, float sigma);
};

}
}
}

#endif /* video_gaussian_blur_effect_h */
