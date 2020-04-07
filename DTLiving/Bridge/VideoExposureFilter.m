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
    self = [super initWithName:[NSString stringWithCString:kVideoExposureEffect encoding:NSUTF8StringEncoding]];
    if (self) {
        self.exposure = 0.0;
    }
    return self;
}

- (NSDictionary *)params {
    NSMutableDictionary *dict = [NSMutableDictionary new];
    dict[[NSString stringWithCString:kVideoExposureEffectExposure encoding:NSUTF8StringEncoding]] = @(self.exposure);
    return dict;
}

@end
