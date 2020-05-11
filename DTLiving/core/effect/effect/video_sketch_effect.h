//
//  video_sketch_effect.h
//  DTLiving
//
//  Created by Dan Jiang on 2020/5/11.
//  Copyright © 2020 Dan Thought Studio. All rights reserved.
//

#ifndef DTLIVING_EFFECT_EFFECT_VIDEO_SKETCH_EFFECT_H_
#define DTLIVING_EFFECT_EFFECT_VIDEO_SKETCH_EFFECT_H_

#include "video_two_pass_effect.h"

namespace dtliving {
namespace effect {
namespace effect {

class VideoSketchEffect: public VideoTwoPassEffect {
public:
    static std::string FragmentShader();

    VideoSketchEffect(std::string name);
    
    virtual void LoadShaderSource();
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

#endif /* video_sketch_effect_h */
