//
//  video_two_pass_effect.h
//  DTLiving
//
//  Created by Dan Jiang on 2020/4/15.
//  Copyright © 2020 Dan Thought Studio. All rights reserved.
//

#ifndef DTLIVING_EFFECT_VIDEO_TWO_PASS_EFFECT_H_
#define DTLIVING_EFFECT_VIDEO_TWO_PASS_EFFECT_H_

#include "video_effect.h"

namespace dtliving {
namespace effect {

class VideoTwoPassEffect: public VideoEffect {
public:
    VideoTwoPassEffect(const char *name, const char *vertex_shader_file, const char *fragment_shader_file,
                       const char *vertex_shader_file2, const char *fragment_shader_file2);

    virtual void Init();

protected:
    virtual void BeforeDrawArrays();
    
    ShaderProgram *program2_;

private:
    const char *vertex_shader_file2_;
    const char *fragment_shader_file2_;

    GLuint a_position2_;
    
    GLuint a_texcoord2_;
};

}
}

#endif /* video_two_pass_effect_h */
