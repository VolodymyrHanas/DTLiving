//
//  video_effect_processor.h
//  DTLiving
//
//  Created by Dan Jiang on 2020/3/15.
//  Copyright © 2020 Dan Thought Studio. All rights reserved.
//

#ifndef DTLIVING_EFFECT_VIDEO_EFFECT_PROCESSOR_H_
#define DTLIVING_EFFECT_VIDEO_EFFECT_PROCESSOR_H_

#include <vector>

#include "video_frame.h"
#include "video_effect.h"

namespace dtliving {
namespace effect {

class VideoEffectProcessor {
public:
    VideoEffectProcessor();
    ~VideoEffectProcessor();
    
    void Init(const char *vertex_shader_file, const char *fragment_shader_file);
    void AddEffect(const char *name, const char *vertex_shader_file, const char *fragment_shader_file);
    void SetClearColor(const char *name, GLfloat red, GLfloat green, GLfloat blue, GLfloat alpha);
    void SetIgnoreAspectRatio(const char *name, bool ignore_aspect_ratio);
    void LoadResources(const char *name, std::vector<std::string> resources);
    void SetPositions(const char *name, GLfloat *positions);
    void SetTextureCoordinates(const char *name, GLfloat *texture_coordinates);
    void SetEffectParamInt(const char *name, const char *param, GLint *value, int size);
    void SetEffectParamFloat(const char *name, const char *param, GLfloat *value, int size);
    void Process(VideoFrame input_frame, VideoFrame output_frame);
    // TODO: switch effect
private:
    VideoEffect *no_effect_;
    std::vector<VideoEffect *> effects_ {};
};

}
}

#endif /* video_effect_processor_h */
