//
//  VideoSepiaFilter.m
//  DTLiving
//
//  Created by Dan Jiang on 2020/4/9.
//  Copyright © 2020 Dan Thought Studio. All rights reserved.
//

#import "VideoSepiaFilter.h"

@implementation VideoSepiaFilter

- (instancetype)init {
    self = [super initWithName:kVideoSepiaEffect];
    if (self) {
        self.intensity = 1.0;
        self.colorMatrix = VideoMat4Make(VideoVec4Make(0.3588, 0.7044, 0.1368, 0.0),
                                         VideoVec4Make(0.2990, 0.5870, 0.1140, 0.0),
                                         VideoVec4Make(0.2392, 0.4696, 0.0912, 0.0),
                                         VideoVec4Make(0.0, 0.0, 0.0, 1.0));
    }
    return self;
}

- (NSString *)fragmentShaderFile {
    return @"effect_color_matrix_fragment";
}

- (NSDictionary<NSString*, NSArray<NSNumber*>*> *)floatParams {
    return @{[NSString stringWithUTF8String:kVideoColorMatrixEffectIntensity]: @[@(self.intensity)],
             [NSString stringWithUTF8String:kVideoColorMatrixEffectColorMatrix]: [self mat4ToArray:self.colorMatrix]};
}

@end
