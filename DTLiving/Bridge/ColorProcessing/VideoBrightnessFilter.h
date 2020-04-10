//
//  VideoBrightnessFilter.h
//  DTLiving
//
//  Created by Dan Jiang on 2020/3/17.
//  Copyright © 2020 Dan Thought Studio. All rights reserved.
//

#import "VideoFilter.h"

NS_ASSUME_NONNULL_BEGIN

@interface VideoBrightnessFilter : VideoFilter

@property (nonatomic, assign) float brightness;

- (instancetype)init;

@end

NS_ASSUME_NONNULL_END
