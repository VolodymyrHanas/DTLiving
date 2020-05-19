//
//  VideoTransformFilter.h
//  DTLiving
//
//  Created by Dan Jiang on 2020/4/13.
//  Copyright © 2020 Dan Thought Studio. All rights reserved.
//

#import "VideoFilter.h"
#import <QuartzCore/QuartzCore.h>

NS_ASSUME_NONNULL_BEGIN

@interface VideoTransformFilter : VideoFilter

@property (nonatomic, assign) CGAffineTransform affineTransform;
@property (nonatomic, assign) CATransform3D transform3D;

- (instancetype)init;

@end

NS_ASSUME_NONNULL_END
