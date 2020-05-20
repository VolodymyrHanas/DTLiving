//
//  video_water_mask_effect.hpp
//  DTLiving
//
//  Created by Dan Jiang on 2020/5/18.
//  Copyright © 2020 Dan Thought Studio. All rights reserved.
//

#ifndef DTLIVING_EFFECT_COMPOSITION_WATER_MASK_EFFECT_H_
#define DTLIVING_EFFECT_COMPOSITION_WATER_MASK_EFFECT_H_

#include "video_composition_effect.h"

namespace dtliving {
namespace effect {
namespace composition {

class VideoWaterMaskEffect: public VideoCompositionEffect {
public:
    VideoWaterMaskEffect(std::string name);
    
    virtual void LoadResources(std::vector<std::string> resources);

protected:
    virtual void BeforeSetPositions(GLsizei width, GLsizei height, int program_index);

    VideoFrame image_frame_;
};

}
}
}

#endif /* video_water_mask_effect_h */
