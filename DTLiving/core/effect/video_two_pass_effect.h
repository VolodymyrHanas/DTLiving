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
    VideoTwoPassEffect(std::string name);

    void LoadShaderSource(std::string vertex_shader_source1, std::string fragment_shader_source1,
                          std::string vertex_shader_source2, std::string fragment_shader_source2);
    virtual void LoadUniform();
    virtual void Render(VideoFrame input_frame, VideoFrame output_frame, std::vector<GLfloat> positions, std::vector<GLfloat> texture_coordinates);

protected:    
    ShaderProgram *program2_;
    GLuint a_position2_;
    GLuint a_texcoord2_;
    GLint u_texture2_;
};

}
}

#endif /* video_two_pass_effect_h */
