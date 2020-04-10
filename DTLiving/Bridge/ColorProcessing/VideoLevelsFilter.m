//
//  VideoLevelsFilter.m
//  DTLiving
//
//  Created by Dan Jiang on 2020/4/9.
//  Copyright © 2020 Dan Thought Studio. All rights reserved.
//

#import "VideoLevelsFilter.h"

@implementation VideoLevelsFilter

- (instancetype)init {
    self = [super initWithName:kVideoLevelsEffect];
    if (self) {
        [self setRedMin:0.0 gamma:1.0 max:1.0 minOut:0.0 maxOut:1.0];
        [self setGreenMin:0.0 gamma:1.0 max:1.0 minOut:0.0 maxOut:1.0];
        [self setBlueMin:0.0 gamma:1.0 max:1.0 minOut:0.0 maxOut:1.0];
    }
    return self;
}

- (void)setRedMin:(float)min gamma:(float)mid max:(float)max minOut:(float)minOut maxOut:(float)maxOut {
    self.min = VideoVec3Make(min, self.min.y, self.min.z);
    self.mid = VideoVec3Make(mid, self.mid.y, self.mid.z);
    self.max = VideoVec3Make(max, self.max.y, self.max.z);
    self.minOut = VideoVec3Make(minOut, self.minOut.y, self.minOut.z);
    self.maxOut = VideoVec3Make(maxOut, self.maxOut.y, self.maxOut.z);
}

- (void)setGreenMin:(float)min gamma:(float)mid max:(float)max minOut:(float)minOut maxOut:(float)maxOut {
    self.min = VideoVec3Make(self.min.x, min, self.min.z);
    self.mid = VideoVec3Make(self.mid.x, mid, self.mid.z);
    self.max = VideoVec3Make(self.max.x, max, self.max.z);
    self.minOut = VideoVec3Make(self.minOut.x, minOut, self.minOut.z);
    self.maxOut = VideoVec3Make(self.maxOut.x, maxOut, self.maxOut.z);
}

- (void)setBlueMin:(float)min gamma:(float)mid max:(float)max minOut:(float)minOut maxOut:(float)maxOut {
    self.min = VideoVec3Make(self.min.x, self.min.y, min);
    self.mid = VideoVec3Make(self.mid.x, self.mid.y, mid);
    self.max = VideoVec3Make(self.max.x, self.max.y, max);
    self.minOut = VideoVec3Make(self.minOut.x, self.minOut.y, minOut);
    self.maxOut = VideoVec3Make(self.maxOut.x, self.maxOut.y, maxOut);
}

- (NSDictionary<NSString*, NSArray<NSNumber*>*> *)floatParams {
    return @{[NSString stringWithUTF8String:kVideoLevelsEffectLevelMinimum]: [self vec3ToArray:self.min],
             [NSString stringWithUTF8String:kVideoLevelsEffectLevelMiddle]: [self vec3ToArray:self.mid],
             [NSString stringWithUTF8String:kVideoLevelsEffectLevelMaximum]: [self vec3ToArray:self.max],
             [NSString stringWithUTF8String:kVideoLevelsEffectMinOutput]: [self vec3ToArray:self.minOut],
             [NSString stringWithUTF8String:kVideoLevelsEffectMaxOutput]: [self vec3ToArray:self.maxOut]};
}

@end
