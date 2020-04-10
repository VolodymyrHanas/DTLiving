//
//  VideoRGBFilter.m
//  DTLiving
//
//  Created by Dan Jiang on 2020/3/19.
//  Copyright © 2020 Dan Thought Studio. All rights reserved.
//

#import "VideoRGBFilter.h"

@implementation VideoRGBFilter

- (instancetype)init {
    self = [super initWithName:kVideoRGBEffect];
    if (self) {
        self.red = 1.0;
        self.green = 1.0;
        self.blue = 1.0;
    }
    return self;
}

- (NSDictionary<NSString*, NSArray<NSNumber*>*> *)floatParams {
    return @{[NSString stringWithUTF8String:kVideoRGBEffectRed]: @[@(self.red)],
             [NSString stringWithUTF8String:kVideoRGBEffectGreen]: @[@(self.green)],
             [NSString stringWithUTF8String:kVideoRGBEffectBlue]: @[@(self.blue)]};
}

@end
