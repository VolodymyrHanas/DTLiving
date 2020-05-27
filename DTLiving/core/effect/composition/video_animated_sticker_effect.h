//
//  video_animated_sticker_effect.h
//  DTLiving
//
//  Created by Dan Jiang on 2020/5/19.
//  Copyright © 2020 Dan Thought Studio. All rights reserved.
//

#ifndef DTLIVING_EFFECT_COMPOSITION_VIDEO_ANIMATED_STICKER_EFFECT_H_
#define DTLIVING_EFFECT_COMPOSITION_VIDEO_ANIMATED_STICKER_EFFECT_H_

#include "matrix.h"
#include "video_composition_effect.h"

namespace dtliving {
namespace effect {
namespace composition {

class VideoAnimatedStickerEffect: public VideoCompositionEffect {
public:
    VideoAnimatedStickerEffect(std::string name);
    
    virtual void LoadResources(std::vector<std::string> resources);

protected:
    virtual void Update(GLsizei width, GLsizei height);
    
    virtual void BeforeSetPositions(GLsizei width, GLsizei height, int program_index);
    virtual void BeforeDrawArrays(GLsizei width, GLsizei height, int program_index);

    std::vector<VideoFrame> image_frames_;
    
private:
    std::vector<VideoFrame>::size_type image_index_;
    mat4 model_matrix_;
};

}
}
}

#endif /* video_animated_sticker_effect_h */
