//
//  VideoToonFilter.m
//  DTLiving
//
//  Created by Dan Jiang on 2020/5/11.
//  Copyright © 2020 Dan Thought Studio. All rights reserved.
//

#import "VideoToonFilter.h"

@implementation VideoToonFilter

- (instancetype)init {
    self = [super initWithName:kVideoToonEffect];
    if (self) {
        self.threshold = 0.2;
        self.quantizationLevels = 10.0;
    }
    return self;
}

- (NSDictionary<NSString*, NSArray<NSNumber*>*> *)floatParams {
    return @{[NSString stringWithUTF8String:kVideoToonEffectThreshold]: @[@(self.threshold)],
             [NSString stringWithUTF8String:kVideoToonEffectQuantizationLevels]: @[@(self.quantizationLevels)]};
}

@end
