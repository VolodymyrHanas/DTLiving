//
//  VideoAlphaBlendFilter.h
//  DTLiving
//
//  Created by Dan Jiang on 2020/5/9.
//  Copyright © 2020 Dan Thought Studio. All rights reserved.
//

#import "VideoFilter.h"

NS_ASSUME_NONNULL_BEGIN

@interface VideoAlphaBlendFilter : VideoFilter

@property (nonatomic, copy) NSString *imageFile;
@property (nonatomic, assign) float mixturePercent;

- (instancetype)init;

@end

NS_ASSUME_NONNULL_END
