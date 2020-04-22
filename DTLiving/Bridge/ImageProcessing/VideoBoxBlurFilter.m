//
//  VideoBoxBlurFilter.m
//  DTLiving
//
//  Created by Dan Jiang on 2020/4/22.
//  Copyright © 2020 Dan Thought Studio. All rights reserved.
//

#import "VideoBoxBlurFilter.h"

@implementation VideoBoxBlurFilter

- (instancetype)init {
    self = [super initWithName:kVideoBoxBlurEffect];
    if (self) {
        _blurRadiusInPixels = 2.0;
    }
    return self;
}

- (NSDictionary<NSString*, NSArray<NSNumber*>*> *)floatParams {
    return @{[NSString stringWithUTF8String:kVideoBoxBlurEffectBlurRadiusInPixels]: @[@(self.blurRadiusInPixels)]};
}

@end
