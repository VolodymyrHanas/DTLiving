//
//  VideoEffectProcessorObject.h
//  DTLiving
//
//  Created by Dan Jiang on 2020/3/12.
//  Copyright © 2020 Dan Thought Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VideoFilter.h"

NS_ASSUME_NONNULL_BEGIN

@interface VideoEffectProcessorObject : NSObject

- (instancetype)init;
- (void)addFilter:(VideoFilter *)filter;
- (void)updateFilter:(VideoFilter *)filter;
- (void)processs:(GLuint)inputTexture outputTexture:(GLuint)outputTexture size:(CGSize)size delta:(double)delta;

@end

NS_ASSUME_NONNULL_END
