//
//  VideoBrightnessFilter.m
//  DTLiving
//
//  Created by Dan Jiang on 2020/3/17.
//  Copyright © 2020 Dan Thought Studio. All rights reserved.
//

#import "VideoBrightnessFilter.h"

@implementation VideoBrightnessFilter

- (instancetype)init {
    self = [super initWithName:kVideoBrightnessEffect];
    if (self) {
        self.brightness = 0.0;
    }
    return self;
}

- (NSDictionary<NSString*, NSArray<NSNumber*>*> *)floatParams {
    return @{[NSString stringWithUTF8String:kVideoBrightnessEffectBrightness]: @[@(self.brightness)]};
}

@end
