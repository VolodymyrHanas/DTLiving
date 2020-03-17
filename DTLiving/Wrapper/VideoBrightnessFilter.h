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

- (instancetype)init;

@property (nonatomic, assign) float brightness;

@end

NS_ASSUME_NONNULL_END
