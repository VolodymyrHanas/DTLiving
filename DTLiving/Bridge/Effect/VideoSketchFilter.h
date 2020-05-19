//
//  VideoSketchFilter.h
//  DTLiving
//
//  Created by Dan Jiang on 2020/5/11.
//  Copyright © 2020 Dan Thought Studio. All rights reserved.
//

#import "VideoFilter.h"

NS_ASSUME_NONNULL_BEGIN

@interface VideoSketchFilter : VideoFilter

@property (nonatomic, assign) float edgeStrength;

- (instancetype)init;

@end

NS_ASSUME_NONNULL_END
