//
//  video_texture.cpp
//  DTLiving
//
//  Created by Dan Jiang on 2020/3/18.
//  Copyright © 2020 Dan Thought Studio. All rights reserved.
//

#include "video_texture.h"

namespace dtliving {
namespace opengl {

VideoTexture::VideoTexture(GLsizei width, GLsizei height)
: width(width)
, height(height) {
    glGenTextures(1, &textureName);
    glBindTexture(GL_TEXTURE_2D, textureName);
    
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);

    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, width, height, 0, GL_RGBA, GL_UNSIGNED_BYTE, 0);
    
    glBindTexture(GL_TEXTURE_2D, 0);
}

}
}
