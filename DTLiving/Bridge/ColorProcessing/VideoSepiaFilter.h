//
//  VideoSepiaFilter.h
//  DTLiving
//
//  Created by Dan Jiang on 2020/4/9.
//  Copyright © 2020 Dan Thought Studio. All rights reserved.
//

#import "VideoFilter.h"

NS_ASSUME_NONNULL_BEGIN

@interface VideoSepiaFilter : VideoFilter

@property (nonatomic, assign) VideoMat4 colorMatrix;
@property (nonatomic, assign) float intensity;

- (instancetype)init;

@end

NS_ASSUME_NONNULL_END
