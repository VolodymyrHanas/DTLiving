//
//  VideoExposureFilter.m
//  DTLiving
//
//  Created by Dan Jiang on 2020/4/7.
//  Copyright © 2020 Dan Thought Studio. All rights reserved.
//

#import "VideoExposureFilter.h"

@implementation VideoExposureFilter

- (instancetype)init {
    self = [super initWithName:kVideoExposureEffect];
    if (self) {
        self.exposure = 0.0;
    }
    return self;
}

- (NSDictionary<NSString*, NSArray<NSNumber*>*> *)floatParams {
    return @{[NSString stringWithUTF8String:kVideoExposureEffectExposure]: @[@(self.exposure)]};
}

@end
