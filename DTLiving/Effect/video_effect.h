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
    // TODO: input texture name
    // TODO: params from VideoFilter
    // TODO: Render
    // TODO: which frame buffer bind which texture name, 频繁绑定FBO与解绑定FBO的效率远不如使用同一个FBO在不同的纹理ID上进行切换（Attach）
    // TODO: effect with two shader programs
    
public:
    VideoEffect(const char *vertexShaderFile, const char *fragmentShaderFile);
};

#endif /* video_effect_h */
