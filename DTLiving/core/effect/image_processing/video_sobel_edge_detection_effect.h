//
//  video_sobel_edge_detection_effect.h
//  DTLiving
//
//  Created by Dan Jiang on 2020/4/23.
//  Copyright © 2020 Dan Thought Studio. All rights reserved.
//
//  https://medium.com/datadriveninvestor/understanding-edge-detection-sobel-operator-2aada303b900
//  https://en.wikipedia.org/wiki/Sobel_operator

#ifndef DTLIVING_EFFECT_IMAGE_PROCESSING_VIDEO_SOBEL_EDGE_DETECTION_EFFECT_H_
#define DTLIVING_EFFECT_IMAGE_PROCESSING_VIDEO_SOBEL_EDGE_DETECTION_EFFECT_H_

#include "video_two_pass_texture_sampling_effect.h"

namespace dtliving {
namespace effect {
namespace image_processing {

class VideoSobelEdgeDetectionEffect: public VideoTwoPassTextureSamplingEffect {
public:
    static std::string FragmentShader();

    VideoSobelEdgeDetectionEffect(std::string name);
    
    void LoadShaderSource();
    virtual void LoadUniform();

protected:
    virtual void BeforeDrawArrays(GLsizei width, GLsizei height, int program_index);

private:
    GLint u_texelWidth_;
    GLint u_texelHeight_;
};

}
}
}

#endif /* video_sobel_edge_detection_effect_h */
