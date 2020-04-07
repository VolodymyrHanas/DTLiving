//
//  VideoGammaFilter.h
//  DTLiving
//
//  Created by Dan Jiang on 2020/4/7.
//  Copyright © 2020 Dan Thought Studio. All rights reserved.
//

#import "VideoFilter.h"

NS_ASSUME_NONNULL_BEGIN

@interface VideoGammaFilter : VideoFilter

- (instancetype)init;

@property (nonatomic, assign) float gamma;

@end

NS_ASSUME_NONNULL_END
