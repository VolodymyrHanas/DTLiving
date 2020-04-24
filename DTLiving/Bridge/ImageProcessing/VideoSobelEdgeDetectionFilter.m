//
//  VideoSobelEdgeDetectionFilter.m
//  DTLiving
//
//  Created by Dan Jiang on 2020/4/24.
//  Copyright © 2020 Dan Thought Studio. All rights reserved.
//

#import "VideoSobelEdgeDetectionFilter.h"

@implementation VideoSobelEdgeDetectionFilter

- (instancetype)init {
    self = [super initWithName:kVideoSobelEdgeDetectionEffect];
    if (self) {
        _edgeStrength = 1.0;
    }
    return self;
}

- (NSDictionary<NSString*, NSArray<NSNumber*>*> *)floatParams {
    return @{[NSString stringWithUTF8String:kVideoSobelEdgeDetectionEffectEdgeStrength]: @[@(self.edgeStrength)]};
}

@end
