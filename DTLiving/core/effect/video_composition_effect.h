//
//  video_composition_effect.h
//  DTLiving
//
//  Created by Dan Jiang on 2020/5/12.
//  Copyright © 2020 Dan Thought Studio. All rights reserved.
//

#ifndef DTLIVING_EFFECT_VIDEO_COMPOSITION_EFFECT_H_
#define DTLIVING_EFFECT_VIDEO_COMPOSITION_EFFECT_H_

#include "video_effect.h"

namespace dtliving {
namespace effect {

class VideoCompositionEffect: public VideoEffect {
public:
    static std::string VertexShader();

    VideoCompositionEffect(std::string name);

    virtual void LoadShaderSource();
    virtual void LoadUniform();
    virtual void BeforeDrawArrays(GLsizei width, GLsizei height, int program_index);
    virtual void Render(VideoFrame input_frame, VideoFrame output_frame, std::vector<GLfloat> positions, std::vector<GLfloat> texture_coordinates);

protected:
    ShaderProgram *program2_;
    GLuint a_position2_;
    GLuint a_texcoord2_;
    GLint u_texture2_;
    GLint u_orthographic_matrix2_;
    std::vector<GLfloat> positions2_;
};

}
}

#endif /* video_two_pass_effect_h */
