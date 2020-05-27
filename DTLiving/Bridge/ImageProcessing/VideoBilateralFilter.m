//
//  VideoBilateralFilter.m
//  DTLiving
//
//  Created by Dan Jiang on 2020/5/27.
//  Copyright © 2020 Dan Thought Studio. All rights reserved.
//

#import "VideoBilateralFilter.h"

@implementation VideoBilateralFilter

- (instancetype)init {
    self = [super initWithName:kVideoBilateralEffect];
    if (self) {
        _distanceNormalizationFactor = 8.0;
    }
    return self;
}

- (NSString *)vertexShaderFile {
    return [NSString stringWithFormat:@"%@_vertex", self.name];
}

- (NSDictionary<NSString*, NSArray<NSNumber*>*> *)floatParams {
    return @{[NSString stringWithUTF8String:kVideoBilateralEffectDistanceNormalizationFactor]: @[@(self.distanceNormalizationFactor)]};
}

@end
