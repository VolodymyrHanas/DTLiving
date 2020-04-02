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
    self = [super initWithName:[NSString stringWithCString:kVideoRGBEffect encoding:NSUTF8StringEncoding]];
    if (self) {
    }
    return self;
}

- (NSDictionary *)params {
    NSMutableDictionary *dict = [NSMutableDictionary new];
    dict[[NSString stringWithCString:kVideoRGBEffectRed encoding:NSUTF8StringEncoding]] = @(self.red);
    dict[[NSString stringWithCString:kVideoRGBEffectGreen encoding:NSUTF8StringEncoding]] = @(self.green);
    dict[[NSString stringWithCString:kVideoRGBEffectBlue encoding:NSUTF8StringEncoding]] = @(self.blue);
    return dict;
}

@end
