//
//  VideoSharpenFilter.m
//  DTLiving
//
//  Created by Dan Jiang on 2020/5/26.
//  Copyright © 2020 Dan Thought Studio. All rights reserved.
//

#import "VideoSharpenFilter.h"

@implementation VideoSharpenFilter

- (instancetype)init {
    self = [super initWithName:kVideoSharpenEffect];
    if (self) {
        _sharpness = 0;
    }
    return self;
}

- (NSString *)vertexShaderFile {
    return [NSString stringWithFormat:@"%@_vertex", self.name];
}

- (NSDictionary<NSString*, NSArray<NSNumber*>*> *)floatParams {
    return @{[NSString stringWithUTF8String:kVideoSharpenEffectSharpness]: @[@(self.sharpness)]};
}

@end
