//
//  VideoMaskFilter.m
//  DTLiving
//
//  Created by Dan Jiang on 2020/5/9.
//  Copyright © 2020 Dan Thought Studio. All rights reserved.
//

#import "VideoMaskFilter.h"

@implementation VideoMaskFilter

- (instancetype)init {
    self = [super initWithName:kVideoMaskEffect];
    if (self) {
        self.color = VideoVec4Make(1.0, 1.0, 1.0, 1.0);
    }
    return self;
}

- (NSString *)vertexShaderFile {
    return @"effect_two_input_vertex";
}

- (NSDictionary<NSString*, NSArray<NSNumber*>*> *)floatParams {
    return @{[NSString stringWithUTF8String:kVideoMaskEffectColor]: [self vec4ToArray:self.color]};
}

- (NSArray<NSString*> *)resources {
    return @[self.imageName];
}

@end
