//
//  VideoBilateralFilter.h
//  DTLiving
//
//  Created by Dan Jiang on 2020/5/27.
//  Copyright © 2020 Dan Thought Studio. All rights reserved.
//

#import "VideoFilter.h"

NS_ASSUME_NONNULL_BEGIN

@interface VideoBilateralFilter : VideoFilter

@property (nonatomic, assign) float distanceNormalizationFactor;

- (instancetype)init;

@end

NS_ASSUME_NONNULL_END
