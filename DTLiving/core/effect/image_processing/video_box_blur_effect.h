//
//  video_box_blur_effect.h
//  DTLiving
//
//  Created by Dan Jiang on 2020/4/21.
//  Copyright © 2020 Dan Thought Studio. All rights reserved.
//

#ifndef DTLIVING_EFFECT_IMAGE_PROCESSING_VIDEO_BOX_BLUR_EFFECT_H_
#define DTLIVING_EFFECT_IMAGE_PROCESSING_VIDEO_BOX_BLUR_EFFECT_H_

#include "video_gaussian_blur_effect.h"

namespace dtliving {
namespace effect {
namespace image_processing {

class VideoBoxBlurEffect: public VideoTwoPassTextureSamplingEffect {
public:
    VideoBoxBlurEffect(std::string name);
    
    void LoadShaderSource();

protected:
    virtual void BeforeDrawArrays(GLsizei width, GLsizei height, int program_index);

private:
    static std::string VertexShaderOptimized(int blur_radius);
    static std::string FragmentShaderOptimized(int blur_radius);
    
    int blur_radius_;
};

}
}
}

#endif /* video_box_blur_effect_h */
