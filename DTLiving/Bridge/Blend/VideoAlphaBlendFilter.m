//
//  VideoAlphaBlendFilter.m
//  DTLiving
//
//  Created by Dan Jiang on 2020/5/9.
//  Copyright © 2020 Dan Thought Studio. All rights reserved.
//

#import "VideoAlphaBlendFilter.h"

@implementation VideoAlphaBlendFilter

- (instancetype)init {
    self = [super initWithName:kVideoAlphaBlendEffect];
    if (self) {
        _mixturePercent = 1.0;
    }
    return self;
}

- (NSString *)vertexShaderFile {
    return @"effect_two_input_vertex";
}

- (NSString *)fragmentShaderFile {
    return [NSString stringWithFormat:@"%@_fragment", self.name];
}

- (NSDictionary<NSString*, NSArray<NSNumber*>*> *)floatParams {
    return @{[NSString stringWithUTF8String:kVideoAlphaBlendEffectMixturePercent]: @[@(self.mixturePercent)]};
}

- (NSArray<NSString*> *)resources {
    return @[self.imageName];
}

@end
