//
//  video_color_matrix_effect.h
//  DTLiving
//
//  Created by Dan Jiang on 2020/4/9.
//  Copyright © 2020 Dan Thought Studio. All rights reserved.
//

#ifndef DTLIVING_EFFECT_COLOR_PROCESSING_VIDEO_COLOR_MATRIX_EFFECT_H_
#define DTLIVING_EFFECT_COLOR_PROCESSING_VIDEO_COLOR_MATRIX_EFFECT_H_

#include "video_effect.h"

namespace dtliving {
namespace effect {
namespace color_processing {

class VideoColorMatrixEffect: public VideoEffect {
public:
    VideoColorMatrixEffect(const char *name, const char *vertex_shader_file, const char *fragment_shader_file);

    void BeforeDrawArrays();
};

}
}
}

#endif /* video_color_matrix_effect_h */
