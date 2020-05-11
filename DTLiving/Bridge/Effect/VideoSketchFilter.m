//
//  VideoSketchFilter.m
//  DTLiving
//
//  Created by Dan Jiang on 2020/5/11.
//  Copyright © 2020 Dan Thought Studio. All rights reserved.
//

#import "VideoSketchFilter.h"

@implementation VideoSketchFilter

- (instancetype)init {
    self = [super initWithName:kVideoSketchEffect];
    if (self) {
        _edgeStrength = 1.0;
    }
    return self;
}

- (NSDictionary<NSString*, NSArray<NSNumber*>*> *)floatParams {
    return @{[NSString stringWithUTF8String:kVideoSketchEffectEdgeStrength]: @[@(self.edgeStrength)]};
}

@end
