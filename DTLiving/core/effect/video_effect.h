//
//  video_effect.h
//  DTLiving
//
//  Created by Dan Jiang on 2020/3/12.
//  Copyright © 2020 Dan Thought Studio. All rights reserved.
//

#ifndef DTLIVING_EFFECT_VIDEO_EFFECT_H_
#define DTLIVING_EFFECT_VIDEO_EFFECT_H_

#include <map>

#include "shader_program.h"
#include "video_frame.h"
#include "video_effect_uniform.h"

namespace dtliving {
namespace effect {

class VideoEffect {    
public:
    VideoEffect(const char *name, const char *vertex_shader_file, const char *fragment_shader_file);
    ~VideoEffect();
    
    void Init();
    void SetUniform(const char *name, VideoEffectUniform uniform);
    void Render(VideoFrame input_frame, VideoFrame output_frame);
    void Render(VideoFrame input_frame, VideoFrame output_frame, GLfloat *positions, GLfloat *texture_coordinates);

    std::string get_name();

protected:
    virtual void BeforeDrawArrays();
    
    ShaderProgram *program_;
    std::map<std::string, VideoEffectUniform> uniforms_;

private:
    std::string name_;
    const char *vertex_shader_file_;
    const char *fragment_shader_file_;
    GLuint a_position_;
    GLuint a_texcoord_;
    GLint u_texture_;

    // TODO: effect with two shader programs
    // TODO: effect with time
    
};

}
}

#endif /* video_effect_h */
