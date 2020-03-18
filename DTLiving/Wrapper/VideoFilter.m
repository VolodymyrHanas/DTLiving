//
//  VideoFilter.m
//  DTLiving
//
//  Created by Dan Jiang on 2020/3/17.
//  Copyright © 2020 Dan Thought Studio. All rights reserved.
//

#import "VideoFilter.h"

@interface VideoFilter ()

@end

@implementation VideoFilter

- (instancetype)initWithName:(NSString *)name {
    self = [super init];
    if (self) {
        self.name = name;
    }
    return self;
}

- (NSString *)vertexShaderFile {
    return @"effect_vertex";
}

- (NSString *)fragmentShaderFile {
    return [NSString stringWithFormat:@"%@_fragment", self.name];
}

@end
