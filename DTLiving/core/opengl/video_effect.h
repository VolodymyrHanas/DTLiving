//
//  video_effect.h
//  DTLiving
//
//  Created by Dan Jiang on 2020/3/12.
//  Copyright © 2020 Dan Thought Studio. All rights reserved.
//

#ifndef DTLIVING_OPENGL_VIDEO_EFFECT_H_
#define DTLIVING_OPENGL_VIDEO_EFFECT_H_

#include "shader_program.h"

namespace dtliving {
namespace opengl {

extern const char *kVideoBrightnessEffect;
extern const char *kVideoBrightnessEffectBrightness;

extern const char *kVideoRGBEffect;
extern const char *kVideoRGBEffectRed;
extern const char *kVideoRGBEffectGreen;
extern const char *kVideoRGBEffectBlue;

class VideoEffect {    
public:
    VideoEffect(const char *name, const char *vertex_shader_file, const char *fragment_shader_file);
    ~VideoEffect();
    
    void Init();
    void SetUniformFloat(const char *name, GLfloat value);
    void Render(GLuint input_texture, GLfloat *square_vertices, GLfloat *texture_vertices);
    
    const char* get_name();
    
private:
    const char *name_;
    const char *vertex_shader_file_;
    const char *fragment_shader_file_;
    ShaderProgram *program_;
    GLuint a_position_;
    GLuint a_texcoord_;
    GLint u_texture_;
    
    // TODO: params from VideoFilter
    // TODO: which frame buffer bind which texture name, 频繁绑定FBO与解绑定FBO的效率远不如使用同一个FBO在不同的纹理ID上进行切换（Attach）
    // TODO: effect with two shader programs
    // TODO: effect with time
    
};

}
}

#endif /* video_effect_h */
