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

    std::string get_name() { return name_; }
    bool get_is_orthographic() { return is_orthographic_; }
    void set_is_orthographic(bool is_orthographic) { is_orthographic_ = is_orthographic; }
    bool get_ignore_aspect_ratio() { return ignore_aspect_ratio_; }
    void set_ignore_aspect_ratio(bool ignore_aspect_ratio) { ignore_aspect_ratio_ = ignore_aspect_ratio; }
    void set_clear_color(GLfloat red, GLfloat green, GLfloat blue, GLfloat alpha) {
        clear_color_red_ = red;
        clear_color_green_ = green;
        clear_color_blue_ = blue;
        clear_color_alpha_ = alpha;
    }
    void get_clear_color(GLfloat *clear_color) {
        *clear_color = clear_color_red_;
        *(clear_color + 1) = clear_color_green_;
        *(clear_color + 2) = clear_color_blue_;
        *(clear_color + 3) = clear_color_alpha_;
    }

protected:
    virtual void BeforeDrawArrays();
    
    ShaderProgram *program_;
    std::map<std::string, VideoEffectUniform> uniforms_;

private:
    void caculateOrthographicMatrix(GLfloat width, GLfloat height);
    
    std::string name_;
    const char *vertex_shader_file_;
    const char *fragment_shader_file_;
    GLuint a_position_;
    GLuint a_texcoord_;
    GLint u_texture_;
    GLint u_orthographic_matrix_;
    bool is_orthographic_;
    bool ignore_aspect_ratio_;
    GLfloat clear_color_red_;
    GLfloat clear_color_green_;
    GLfloat clear_color_blue_;
    GLfloat clear_color_alpha_;

    // TODO: effect with two shader programs
    // TODO: effect with two textures as input
    // TODO: effect with time
    
};

}
}

#endif /* video_effect_h */
