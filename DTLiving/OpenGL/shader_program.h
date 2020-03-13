//
//  shader_program.h
//  DTLiving
//
//  Created by Dan Jiang on 2020/3/12.
//  Copyright © 2020 Dan Thought Studio. All rights reserved.
//

#ifndef shader_program_h
#define shader_program_h

#include <OpenGLES/ES2/gl.h>
#include <OpenGLES/ES2/glext.h>
#include <iostream>

class ShaderProgram {
public:
    ShaderProgram(char *vertexShaderSource, char *fragmentShaderSource);
    void useProgram();
    void deleteProgram();
    GLuint attributeLocation(char *name);
    GLuint uniformLocation(char *name);
private:
    GLuint program = 0;
    GLuint compileShader(const char *source, GLenum type);
};

#endif /* shader_program_h */
