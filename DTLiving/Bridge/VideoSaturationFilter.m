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
    self = [super initWithName:[NSString stringWithCString:kVideoSaturationEffect encoding:NSUTF8StringEncoding]];
    if (self) {
        self.saturation = 1.0;
    }
    return self;
}

- (NSDictionary *)params {
    NSMutableDictionary *dict = [NSMutableDictionary new];
    dict[[NSString stringWithCString:kVideoSaturationEffectSaturation encoding:NSUTF8StringEncoding]] = @(self.saturation);
    return dict;
}

@end
