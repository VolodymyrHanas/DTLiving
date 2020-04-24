//
//  video_two_pass_texture_sampling_effect.h
//  DTLiving
//
//  Created by Dan Jiang on 2020/4/17.
//  Copyright © 2020 Dan Thought Studio. All rights reserved.
//

#ifndef DTLIVING_EFFECT_VIDEO_TWO_PASS_TEXTURE_SAMPLING_EFFECT_H_
#define DTLIVING_EFFECT_VIDEO_TWO_PASS_TEXTURE_SAMPLING_EFFECT_H_

#include "video_two_pass_effect.h"

namespace dtliving {
namespace effect {

class VideoTwoPassTextureSamplingEffect: public VideoTwoPassEffect {
public:
    VideoTwoPassTextureSamplingEffect(std::string name);

    virtual void LoadUniform();

protected:
    virtual void BeforeDrawArrays(GLsizei width, GLsizei height, int program_index);

private:
    GLint u_vertical_texelWidthOffset_;
    GLint u_vertical_texelHeightOffset_;
    GLint u_horizontal_texelWidthOffset_;
    GLint u_horizontal_texelHeightOffset_;
    
    GLfloat vertical_texel_spacing_;
    GLfloat horizontal_texel_spacing_;
};

}
}

#endif /* video_two_pass_texture_sampling_h */
