//
//  video_effect.h
//  DTLiving
//
//  Created by Dan Jiang on 2020/3/12.
//  Copyright © 2020 Dan Thought Studio. All rights reserved.
//

#ifndef video_effect_h
#define video_effect_h

#include "shader_program.h"

class VideoEffect {
private:
    ShaderProgram *program;
    // input texture
    // output texture
    // params
    
public:
    VideoEffect(const char *vertexShaderFile, const char *fragmentShaderFile);
};

#endif /* video_effect_h */
