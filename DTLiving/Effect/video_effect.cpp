//
//  video_effect.cpp
//  DTLiving
//
//  Created by Dan Jiang on 2020/3/12.
//  Copyright © 2020 Dan Thought Studio. All rights reserved.
//

#include "video_effect.h"

VideoEffect::VideoEffect(const char *vertexShaderFile, const char *fragmentShaderFile) {
    program = new ShaderProgram(vertexShaderFile, fragmentShaderFile);
}
