//
//  video_bilateral_effect.h
//  DTLiving
//
//  Created by Dan Jiang on 2020/5/26.
//  Copyright © 2020 Dan Thought Studio. All rights reserved.
//

#ifndef DTLIVING_EFFECT_IMAGE_PROCESSING_VIDEO_BILATERAL_EFFECT_H_
#define DTLIVING_EFFECT_IMAGE_PROCESSING_VIDEO_BILATERAL_EFFECT_H_

#include "video_two_pass_texture_sampling_effect.h"

namespace dtliving {
namespace effect {
namespace image_processing {

class VideoBilateralEffect: public VideoTwoPassTextureSamplingEffect {
public:
    VideoBilateralEffect(std::string name);

    void LoadShaderFile(std::string vertex_shader_file, std::string fragment_shader_file);

protected:
    virtual void BeforeDrawArrays(GLsizei width, GLsizei height, int program_index);
};

}
}
}

#endif /* video_bilateral_effect_h */
