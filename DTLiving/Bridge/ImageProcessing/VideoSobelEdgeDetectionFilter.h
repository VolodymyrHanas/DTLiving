//
//  VideoSobelEdgeDetectionFilter.h
//  DTLiving
//
//  Created by Dan Jiang on 2020/4/24.
//  Copyright © 2020 Dan Thought Studio. All rights reserved.
//

#import "VideoFilter.h"

NS_ASSUME_NONNULL_BEGIN

@interface VideoSobelEdgeDetectionFilter : VideoFilter

@property (nonatomic, assign) float edgeStrength;

- (instancetype)init;

@end

NS_ASSUME_NONNULL_END
