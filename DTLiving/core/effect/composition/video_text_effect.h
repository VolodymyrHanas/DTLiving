//
//  video_text_effect.h
//  DTLiving
//
//  Created by Dan Jiang on 2020/5/22.
//  Copyright © 2020 Dan Thought Studio. All rights reserved.
//

#ifndef DTLIVING_EFFECT_COMPOSITION_TEXT_EFFECT_H_
#define DTLIVING_EFFECT_COMPOSITION_TEXT_EFFECT_H_

#include "video_composition_effect.h"

namespace dtliving {
namespace effect {
namespace composition {

class VideoTextEffect: public VideoCompositionEffect {
public:
    VideoTextEffect(std::string name);
    
    virtual void SetTextures(std::vector<VideoFrame> textures);

protected:
    virtual void BeforeSetPositions(GLsizei width, GLsizei height, int program_index);
    virtual void BeforeDrawArrays(GLsizei width, GLsizei height, int program_index);

    VideoFrame image_frame_;
};

}
}
}

#endif /* video_text_effect_h */
