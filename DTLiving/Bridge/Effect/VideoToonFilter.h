//
//  VideoToonFilter.h
//  DTLiving
//
//  Created by Dan Jiang on 2020/5/11.
//  Copyright © 2020 Dan Thought Studio. All rights reserved.
//

#import "VideoFilter.h"

NS_ASSUME_NONNULL_BEGIN

@interface VideoToonFilter : VideoFilter

@property (nonatomic, assign) float threshold;
@property (nonatomic, assign) float quantizationLevels;

- (instancetype)init;

@end

NS_ASSUME_NONNULL_END
