//
//  VideoSaturationFilter.m
//  DTLiving
//
//  Created by Dan Jiang on 2020/4/7.
//  Copyright © 2020 Dan Thought Studio. All rights reserved.
//

#import "VideoSaturationFilter.h"

@implementation VideoSaturationFilter

- (instancetype)init {
    self = [super initWithName:kVideoSaturationEffect];
    if (self) {
        self.saturation = 1.0;
    }
    return self;
}

- (NSDictionary<NSString*, NSArray<NSNumber*>*> *)floatParams {
    return @{[NSString stringWithUTF8String:kVideoSaturationEffectSaturation]: @[@(self.saturation)]};
}

@end
