//
//  VideoWaterMaskFilter.h
//  DTLiving
//
//  Created by Dan Jiang on 2020/5/18.
//  Copyright © 2020 Dan Thought Studio. All rights reserved.
//

#import "VideoFilter.h"
#import <QuartzCore/QuartzCore.h>

NS_ASSUME_NONNULL_BEGIN

@interface VideoWaterMaskFilter : VideoFilter

@property (nonatomic, copy) NSString *imageName;
@property (nonatomic, assign) CGSize scale;
@property (nonatomic, assign) CGFloat rotate; // unit: radian, positive: clockwise, negative: counterclockwise
@property (nonatomic, assign) CGSize translate; // origin at bottom left

- (instancetype)init;

@end

NS_ASSUME_NONNULL_END
