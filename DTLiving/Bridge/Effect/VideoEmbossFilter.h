//
//  VideoEmbossFilter.h
//  DTLiving
//
//  Created by Dan Jiang on 2020/5/9.
//  Copyright © 2020 Dan Thought Studio. All rights reserved.
//

#import "VideoFilter.h"

NS_ASSUME_NONNULL_BEGIN

@interface VideoEmbossFilter : VideoFilter

@property (nonatomic, assign) float intensity; // 0.0 ~ 4.0

- (instancetype)init;

@end

NS_ASSUME_NONNULL_END
