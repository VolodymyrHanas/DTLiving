//
//  VideoAddBlendFilter.m
//  DTLiving
//
//  Created by Dan Jiang on 2020/4/29.
//  Copyright © 2020 Dan Thought Studio. All rights reserved.
//

#import "VideoAddBlendFilter.h"

@implementation VideoAddBlendFilter

- (instancetype)init {
    self = [super initWithName:kVideoAddBlendEffect];
    if (self) {
    }
    return self;
}

- (NSString *)vertexShaderFile {
    return @"effect_two_input_vertex";
}

- (NSString *)fragmentShaderFile {
    return [NSString stringWithFormat:@"%@_fragment", self.name];
}

- (NSArray<NSString*> *)resources {
    return @[self.imageName];
}

@end
