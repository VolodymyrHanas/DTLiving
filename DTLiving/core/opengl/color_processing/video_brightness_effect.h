//
//  video_brightness_effect.h
//  DTLiving
//
//  Created by Dan Jiang on 2020/3/19.
//  Copyright © 2020 Dan Thought Studio. All rights reserved.
//

#ifndef DTLIVING_OPENGL_COLOR_PROCESSING_VIDEO_BRIGHTNESS_EFFECT_H_
#define DTLIVING_OPENGL_COLOR_PROCESSING_VIDEO_BRIGHTNESS_EFFECT_H_

#include "video_effect.h"

namespace dtliving {
namespace opengl {
namespace color_processing {

class VideoBrightnessEffect: public VideoEffect {
public:
    VideoBrightnessEffect(const char *name, const char *vertex_shader_file, const char *fragment_shader_file);

    void BeforeDrawArrays();
};

}
}
}
#endif /* video_brightness_effect_h */
