//
//  VideoLevelsFilter.h
//  DTLiving
//
//  Created by Dan Jiang on 2020/4/9.
//  Copyright © 2020 Dan Thought Studio. All rights reserved.
//

#import "VideoFilter.h"

NS_ASSUME_NONNULL_BEGIN

@interface VideoLevelsFilter : VideoFilter

@property (nonatomic, assign) VideoVec3 min;
@property (nonatomic, assign) VideoVec3 mid;
@property (nonatomic, assign) VideoVec3 max;
@property (nonatomic, assign) VideoVec3 minOut;
@property (nonatomic, assign) VideoVec3 maxOut;

- (instancetype)init;
- (void)setRedMin:(float)min gamma:(float)mid max:(float)max minOut:(float)minOut maxOut:(float)maxOut;
- (void)setGreenMin:(float)min gamma:(float)mid max:(float)max minOut:(float)minOut maxOut:(float)maxOut;
- (void)setBlueMin:(float)min gamma:(float)mid max:(float)max minOut:(float)minOut maxOut:(float)maxOut;

@end

NS_ASSUME_NONNULL_END
