//
//  VideoEmbossFilter.m
//  DTLiving
//
//  Created by Dan Jiang on 2020/5/9.
//  Copyright © 2020 Dan Thought Studio. All rights reserved.
//

#import "VideoEmbossFilter.h"

@implementation VideoEmbossFilter

- (instancetype)init {
    self = [super initWithName:kVideoEmbossEffect];
    if (self) {
        self.intensity = 1.0;
    }
    return self;
}

- (NSDictionary<NSString*, NSArray<NSNumber*>*> *)floatParams {
    VideoMat3 convolutionMatrix = VideoMat3Make(VideoVec3Make(-self.intensity * 2.0, -self.intensity, 0.0),
                                                VideoVec3Make(-self.intensity, 1.0, self.intensity),
                                                VideoVec3Make(0.0, self.intensity, self.intensity * 2.0));
    return @{[NSString stringWithUTF8String:kVideo3x3ConvolutionEffectConvolutionMatrix]: [self mat3ToArray:convolutionMatrix]};
}

@end
