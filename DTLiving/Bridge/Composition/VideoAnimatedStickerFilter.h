//
//  VideoAnimatedStickerFilter.h
//  DTLiving
//
//  Created by Dan Jiang on 2020/5/20.
//  Copyright © 2020 Dan Thought Studio. All rights reserved.
//

#import "VideoFilter.h"
#import <QuartzCore/QuartzCore.h>

NS_ASSUME_NONNULL_BEGIN

@interface VideoAnimatedStickerFilter : VideoFilter

@property (nonatomic, copy) NSString *imageName;
@property (nonatomic, assign) int imageCount;
@property (nonatomic, assign) float imageInterval;
@property (nonatomic, assign) CGSize scale;
@property (nonatomic, assign) CGFloat rotate; // positive: clockwise, negative: counterclockwise
@property (nonatomic, assign) CGSize translate; // origin at bottom left

- (instancetype)init;

@end

NS_ASSUME_NONNULL_END
