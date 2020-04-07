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
    self = [super initWithName:[NSString stringWithCString:kVideoGammaEffect encoding:NSUTF8StringEncoding]];
    if (self) {
        self.gamma = 1.0;
    }
    return self;
}

- (NSDictionary *)params {
    NSMutableDictionary *dict = [NSMutableDictionary new];
    dict[[NSString stringWithCString:kVideoGammaEffectGamma encoding:NSUTF8StringEncoding]] = @(self.gamma);
    return dict;
}

@end
