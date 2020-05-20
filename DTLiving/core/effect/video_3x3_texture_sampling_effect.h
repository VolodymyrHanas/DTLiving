//
//  video_3x3_texture_sampling_effect.h
//  DTLiving
//
//  Created by Dan Jiang on 2020/4/23.
//  Copyright © 2020 Dan Thought Studio. All rights reserved.
//

#ifndef DTLIVING_EFFECT_VIDEO_3x3_TEXTURE_SAMPLING_EFFECT_H_
#define DTLIVING_EFFECT_VIDEO_3x3_TEXTURE_SAMPLING_EFFECT_H_

#include "video_effect.h"

namespace dtliving {
namespace effect {

class Video3x3TextureSamplingEffect: public VideoEffect {
public:
    static std::string VertexShader();

    Video3x3TextureSamplingEffect(std::string name);

    virtual void LoadUniform();
    
protected:
    void LoadFragmentShaderSource(std::string fragment_shader_source);

    virtual void BeforeDrawArrays(GLsizei width, GLsizei height, int program_index);

private:
    GLint u_texelWidth_;
    GLint u_texelHeight_;
};

}
}

#endif /* video_3x3_texture_sampling_effect_h */
