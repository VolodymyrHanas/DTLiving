//
//  VideoTextFilter.h
//  DTLiving
//
//  Created by Dan Jiang on 2020/5/22.
//  Copyright © 2020 Dan Thought Studio. All rights reserved.
//

#import "VideoFilter.h"
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface VideoTextFilter : VideoFilter

@property (nonatomic, assign) CGSize scale;
@property (nonatomic, assign) CGFloat rotate; // unit: radian, positive: clockwise, negative: counterclockwise
@property (nonatomic, assign) CGSize translate; // origin at bottom left

- (instancetype)init;
- (void)setText:(NSAttributedString *)text size:(CGSize)size; // unit: pixel

@end

NS_ASSUME_NONNULL_END
