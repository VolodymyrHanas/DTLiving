//
//  video_3x3_convolution_effect.h
//  DTLiving
//
//  Created by Dan Jiang on 2020/5/9.
//  Copyright © 2020 Dan Thought Studio. All rights reserved.
//

#ifndef DTLIVING_EFFECT_VIDEO_3x3_CONVOLUTION_EFFECT_H_
#define DTLIVING_EFFECT_VIDEO_3x3_CONVOLUTION_EFFECT_H_

#include "video_3x3_texture_sampling_effect.h"

namespace dtliving {
namespace effect {

class Video3x3ConvolutionEffect: public Video3x3TextureSamplingEffect {
public:
    static std::string FragmentShader();

    Video3x3ConvolutionEffect(std::string name);
    
    virtual void LoadShaderSource();

protected:
    virtual void BeforeDrawArrays(GLsizei width, GLsizei height, int program_index);
};

}
}

#endif /* video_3x3_convolution_effect_h */
