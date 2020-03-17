//
//  video_effect_processor.h
//  DTLiving
//
//  Created by Dan Jiang on 2020/3/15.
//  Copyright © 2020 Dan Thought Studio. All rights reserved.
//

#ifndef DTLIVING_OPENGL_VIDEO_EFFECT_PROCESSOR_H_
#define DTLIVING_OPENGL_VIDEO_EFFECT_PROCESSOR_H_

#include <vector>

#include "video_effect.h"

namespace dtliving {
namespace opengl {

class VideoEffectProcessor {
public:
    VideoEffectProcessor();
    ~VideoEffectProcessor();
    
    void AddEffect(const char *name, const char *vertex_shader_file, const char *fragment_shader_file);
    void SetEffectParamFloat(const char *name, const char *param, GLfloat value);
    void Render();
    // TODO: switch effect
private:
    std::vector<VideoEffect *> effects_ {};
};

}
}

#endif /* video_effect_processor_h */
