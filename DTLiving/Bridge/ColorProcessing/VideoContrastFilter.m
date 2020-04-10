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
    self = [super initWithName:kVideoContrastEffect];
    if (self) {
        self.contrast = 1.0;
    }
    return self;
}

- (NSDictionary<NSString*, NSArray<NSNumber*>*> *)floatParams {
    return @{[NSString stringWithUTF8String:kVideoContrastEffectContrast]: @[@(self.contrast)]};
}

@end
