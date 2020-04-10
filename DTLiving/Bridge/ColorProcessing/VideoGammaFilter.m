//
//  VideoGammaFilter.m
//  DTLiving
//
//  Created by Dan Jiang on 2020/4/7.
//  Copyright © 2020 Dan Thought Studio. All rights reserved.
//

#import "VideoGammaFilter.h"

@implementation VideoGammaFilter

- (instancetype)init {
    self = [super initWithName:kVideoGammaEffect];
    if (self) {
        self.gamma = 1.0;
    }
    return self;
}

- (NSDictionary<NSString*, NSArray<NSNumber*>*> *)floatParams {
    return @{[NSString stringWithUTF8String:kVideoGammaEffectGamma]: @[@(self.gamma)]};
}

@end
