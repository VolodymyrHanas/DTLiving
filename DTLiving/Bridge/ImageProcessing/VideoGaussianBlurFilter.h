//
//  VideoGaussianBlurFilter.h
//  DTLiving
//
//  Created by Dan Jiang on 2020/4/20.
//  Copyright © 2020 Dan Thought Studio. All rights reserved.
//

#import "VideoFilter.h"

NS_ASSUME_NONNULL_BEGIN

@interface VideoGaussianBlurFilter : VideoFilter

@property(nonatomic, assign) CGFloat blurRadiusInPixels;

- (instancetype)init;

@end

NS_ASSUME_NONNULL_END
