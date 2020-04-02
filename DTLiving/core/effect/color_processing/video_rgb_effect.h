//
//  video_rgb_effect.hpp
//  DTLiving
//
//  Created by Dan Jiang on 2020/3/19.
//  Copyright © 2020 Dan Thought Studio. All rights reserved.
//

#ifndef DTLIVING_EFFECT_COLOR_PROCESSING_VIDEO_RGB_EFFECT_H_
#define DTLIVING_EFFECT_COLOR_PROCESSING_VIDEO_RGB_EFFECT_H_

#include "video_effect.h"

namespace dtliving {
namespace effect {
namespace color_processing {

class VideoRGBEffect: public VideoEffect {
public:
    VideoRGBEffect(const char *name, const char *vertex_shader_file, const char *fragment_shader_file);

    void BeforeDrawArrays();
};

}
}
}

#endif /* video_rgb_effect_hpp */
