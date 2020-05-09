//
//  video_two_input_effect.h
//  DTLiving
//
//  Created by Dan Jiang on 2020/4/27.
//  Copyright © 2020 Dan Thought Studio. All rights reserved.
//

#ifndef DTLIVING_EFFECT_VIDEO_TWO_INPUT_EFFECT_H_
#define DTLIVING_EFFECT_VIDEO_TWO_INPUT_EFFECT_H_

#include "video_effect.h"

namespace dtliving {
namespace effect {

class VideoTwoInputEffect: public VideoEffect {
public:
    VideoTwoInputEffect(std::string name);

    virtual void LoadUniform();
    virtual void LoadResources(std::vector<std::string> resources);

protected:
    virtual void BeforeDrawArrays(GLsizei width, GLsizei height, int program_index);
    
    GLuint a_texcoord2_;
    GLint u_texture2_;
    
    VideoFrame input_frame2_;
    std::vector<GLfloat> texture_coordinates2_;
};

}
}

#endif /* video_two_input_effect_h */
