//
//  VideoMaskFilter.h
//  DTLiving
//
//  Created by Dan Jiang on 2020/5/9.
//  Copyright © 2020 Dan Thought Studio. All rights reserved.
//

#import "VideoFilter.h"

NS_ASSUME_NONNULL_BEGIN

@interface VideoMaskFilter : VideoFilter

@property (nonatomic, assign) VideoVec4 color;
@property (nonatomic, copy) NSString *imageName;

- (instancetype)init;

@end

NS_ASSUME_NONNULL_END
