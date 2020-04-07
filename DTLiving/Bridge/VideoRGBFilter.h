//
//  VideoRGBFilter.h
//  DTLiving
//
//  Created by Dan Jiang on 2020/3/19.
//  Copyright © 2020 Dan Thought Studio. All rights reserved.
//

#import "VideoFilter.h"

NS_ASSUME_NONNULL_BEGIN

@interface VideoRGBFilter : VideoFilter

- (instancetype)init;

@property (nonatomic, assign) float red; // 0.0 ~ 1.0
@property (nonatomic, assign) float green; // 0.0 ~ 1.0
@property (nonatomic, assign) float blue; // 0.0 ~ 1.0

@end

NS_ASSUME_NONNULL_END
