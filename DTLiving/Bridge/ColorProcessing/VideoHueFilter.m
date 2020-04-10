//
//  VideoHueFilter.m
//  DTLiving
//
//  Created by Dan Jiang on 2020/4/10.
//  Copyright © 2020 Dan Thought Studio. All rights reserved.
//

#import "VideoHueFilter.h"

@implementation VideoHueFilter

- (instancetype)init {
    self = [super initWithName:kVideoHueEffect];
    if (self) {
        self.hue = 90.0;
    }
    return self;
}

- (NSDictionary<NSString*, NSArray<NSNumber*>*> *)floatParams {
    // Convert degrees to radians for hue rotation
    float newHue = fmodf(self.hue, 360.0) * M_PI / 180;
    return @{[NSString stringWithUTF8String:kVideoHueEffectHue]: @[@(newHue)]};
}

@end
