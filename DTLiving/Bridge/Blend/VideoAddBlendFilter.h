//
//  VideoAddBlendFilter.h
//  DTLiving
//
//  Created by Dan Jiang on 2020/4/29.
//  Copyright © 2020 Dan Thought Studio. All rights reserved.
//

#import "VideoFilter.h"

NS_ASSUME_NONNULL_BEGIN

@interface VideoAddBlendFilter : VideoFilter

@property (nonatomic, copy) NSString *imageName;

- (instancetype)init;

@end

NS_ASSUME_NONNULL_END
