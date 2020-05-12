//
//  video_mosaic_effect.h
//  DTLiving
//
//  Created by Dan Jiang on 2020/5/11.
//  Copyright © 2020 Dan Thought Studio. All rights reserved.
//
//  This filter takes an image tileset, the tiles must ascend in luminance.
//  It looks at the video image and replaces each display tile with an image tile according to the luminance of that tile.
//  The idea was to replicate the ASCII video filters seen in other apps, but the tileset can be anything.

#ifndef DTLIVING_EFFECT_EFFECT_VIDEO_MOSAIC_EFFECT_H_
#define DTLIVING_EFFECT_EFFECT_VIDEO_MOSAIC_EFFECT_H_

#include "video_two_input_effect.h"

namespace dtliving {
namespace effect {
namespace effect {

class VideoMosaicEffect: public VideoTwoInputEffect {
public:
    VideoMosaicEffect(std::string name);

protected:
    virtual void BeforeDrawArrays(GLsizei width, GLsizei height, int program_index);
};

}
}
}

#endif /* video_mosaic_effect_h */
