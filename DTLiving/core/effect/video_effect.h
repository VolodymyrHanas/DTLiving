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
    static std::string VertexShader();
    static std::string FragmentShader();

    VideoEffect(std::string name);
    ~VideoEffect();
    
    void LoadShaderFile(std::string vertex_shader_file, std::string fragment_shader_file);
    void LoadShaderSource(std::string vertex_shader_source, std::string fragment_shader_source);
    virtual void LoadUniform();
    void SetPositions(GLfloat *positions);
    void SetTextureCoordinates(GLfloat *texture_coordinates);
    void SetUniform(const char *name, VideoEffectUniform uniform);
    void Render(VideoFrame input_frame, VideoFrame output_frame);
    virtual void Render(VideoFrame input_frame, VideoFrame output_frame, GLfloat *positions, GLfloat *texture_coordinates);

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
    virtual void BeforeDrawArrays(GLsizei width, GLsizei height, int program_index);
    
    GLfloat clear_color_red_;
    GLfloat clear_color_green_;
    GLfloat clear_color_blue_;
    GLfloat clear_color_alpha_;

    ShaderProgram *program_;
    GLuint a_position_;
    GLuint a_texcoord_;
    GLint u_texture_;
    
    std::map<std::string, VideoEffectUniform> uniforms_;

private:
    void caculateOrthographicMatrix(GLfloat width, GLfloat height);
    
    std::string name_;
    
    GLfloat *positions_ = nullptr;
    GLfloat *texture_coordinates_ = nullptr;
            
    GLint u_orthographic_matrix_;
    bool is_orthographic_;
    bool ignore_aspect_ratio_;
};

}
}

#endif /* video_effect_h */
