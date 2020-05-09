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
        _colorRed = 1;
        _colorGreen = 1;
        _colorBlue = 1;
        _colorAlpha = 1;        
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
    return @{[NSString stringWithUTF8String:kVideoMaskEffectColor]: @[@(self.colorRed), @(self.colorGreen), @(self.colorBlue), @(self.colorAlpha)]};
}

- (NSArray<NSString*> *)resources {
    return @[self.imageFile];
}

@end
