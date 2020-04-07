//
//  VideoContrastFilter.m
//  DTLiving
//
//  Created by Dan Jiang on 2020/4/7.
//  Copyright © 2020 Dan Thought Studio. All rights reserved.
//

#import "VideoContrastFilter.h"

@implementation VideoContrastFilter

- (instancetype)init {
    self = [super initWithName:[NSString stringWithCString:kVideoContrastEffect encoding:NSUTF8StringEncoding]];
    if (self) {
        self.contrast = 1.0;
    }
    return self;
}

- (NSDictionary *)params {
    NSMutableDictionary *dict = [NSMutableDictionary new];
    dict[[NSString stringWithCString:kVideoContrastEffectContrast encoding:NSUTF8StringEncoding]] = @(self.contrast);
    return dict;
}

@end
