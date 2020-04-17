//
//  video_two_pass_texture_sampling.h
//  DTLiving
//
//  Created by Dan Jiang on 2020/4/17.
//  Copyright © 2020 Dan Thought Studio. All rights reserved.
//

#ifndef DTLIVING_EFFECT_VIDEO_TWO_PASS_TEXTURE_SAMPLING_EFFECT_H_
#define DTLIVING_EFFECT_VIDEO_TWO_PASS_TEXTURE_SAMPLING_EFFECT_H_

#include "video_two_pass_effect.h"

namespace dtliving {
namespace effect {

class VideoTwoPassTextureSamplingEffect: public VideoTwoPassEffect {
public:
    VideoTwoPassTextureSamplingEffect(const char *name, const char *vertex_shader_file, const char *fragment_shader_file,
                                      const char *vertex_shader_file2, const char *fragment_shader_file2);

    virtual void Init();

protected:
    virtual void BeforeDrawArrays();
};

}
}

#endif /* video_two_pass_texture_sampling_h */
