//
//  VideoCropFilter.h
//  DTLiving
//
//  Created by Dan Jiang on 2020/4/15.
//  Copyright © 2020 Dan Thought Studio. All rights reserved.
//

#import "VideoFilter.h"

NS_ASSUME_NONNULL_BEGIN

@interface VideoCropFilter : VideoFilter

@property (nonatomic, assign) CGRect cropRegion; // origin at top left

- (instancetype)init;

@end

NS_ASSUME_NONNULL_END
