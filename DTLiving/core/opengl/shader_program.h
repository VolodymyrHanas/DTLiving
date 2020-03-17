//
//  shader_program.h
//  DTLiving
//
//  Created by Dan Jiang on 2020/3/12.
//  Copyright © 2020 Dan Thought Studio. All rights reserved.
//

#ifndef DTLIVING_OPENGL_SHADER_PROGRAM_H_
#define DTLIVING_OPENGL_SHADER_PROGRAM_H_

#include <OpenGLES/ES2/gl.h>
#include <OpenGLES/ES2/glext.h>

#include <iostream>
#include <fstream>
#include <string>

namespace dtliving {
namespace opengl {

class ShaderProgram {
public:
    ShaderProgram(const char *vertex_shader_file, const char *fragment_shader_file);
    ~ShaderProgram();
    
    void Load();
    void Use();
    void Delete();
    GLuint AttributeLocation(const char *name);
    GLint UniformLocation(const char *name);
    
private:
    GLuint CompileShader(const char *source, GLenum type);
    
    const char *vertex_shader_file_;
    const char *fragment_shader_file_;
    GLuint program_ = 0;
};

}
}

#endif /* shader_program_h */
