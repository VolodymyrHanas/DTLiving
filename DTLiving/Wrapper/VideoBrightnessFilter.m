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
    self = [super initWithName:[NSString stringWithCString:kVideoBrightnessEffect encoding:NSUTF8StringEncoding]];
    if (self) {
    }
    return self;
}

- (NSDictionary *)params {
    NSMutableDictionary *dict = [NSMutableDictionary new];
    dict[[NSString stringWithCString:kVideoBrightnessEffectBrightness encoding:NSUTF8StringEncoding]] = @(self.brightness);
    return dict;
}

@end
