//
//  VideoHueFilter.h
//  DTLiving
//
//  Created by Dan Jiang on 2020/4/10.
//  Copyright © 2020 Dan Thought Studio. All rights reserved.
//

#import "VideoFilter.h"

NS_ASSUME_NONNULL_BEGIN

@interface VideoHueFilter : VideoFilter

@property (nonatomic, assign) float hue;

- (instancetype)init;

@end

NS_ASSUME_NONNULL_END
