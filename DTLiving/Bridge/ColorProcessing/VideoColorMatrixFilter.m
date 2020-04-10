//
//  VideoColorMatrixFilter.m
//  DTLiving
//
//  Created by Dan Jiang on 2020/4/9.
//  Copyright © 2020 Dan Thought Studio. All rights reserved.
//

#import "VideoColorMatrixFilter.h"

@implementation VideoColorMatrixFilter

- (instancetype)init {
    self = [super initWithName:kVideoColorMatrixEffect];
    if (self) {
        self.intensity = 1.0;
        self.colorMatrix = VideoMat4Make(VideoVec4Make(1.0, 0.0, 0.0, 0.0),
                                         VideoVec4Make(0.0, 1.0, 0.0, 0.0),
                                         VideoVec4Make(0.0, 0.0, 1.0, 0.0),
                                         VideoVec4Make(0.0, 0.0, 0.0, 1.0));
    }
    return self;
}

- (NSDictionary<NSString*, NSArray<NSNumber*>*> *)floatParams {
    return @{[NSString stringWithUTF8String:kVideoColorMatrixEffectIntensity]: @[@(self.intensity)],
             [NSString stringWithUTF8String:kVideoColorMatrixEffectColorMatrix]: [self mat4ToArray:self.colorMatrix]};
}

@end
