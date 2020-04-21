//
//  VideoGaussianBlurFilter.m
//  DTLiving
//
//  Created by Dan Jiang on 2020/4/20.
//  Copyright © 2020 Dan Thought Studio. All rights reserved.
//

#import "VideoGaussianBlurFilter.h"

@implementation VideoGaussianBlurFilter

- (instancetype)init {
    self = [super initWithName:kVideoGaussianBlurEffect];
    if (self) {
        _blurRadiusInPixels = 2.0;
    }
    return self;
}

- (NSDictionary<NSString*, NSArray<NSNumber*>*> *)floatParams {
    return @{[NSString stringWithUTF8String:kVideoGaussianBlurEffectBlurRadiusInPixels]: @[@(self.blurRadiusInPixels)]};
}

@end
