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

@property (nonatomic, assign) float colorRed;
@property (nonatomic, assign) float colorGreen;
@property (nonatomic, assign) float colorBlue;
@property (nonatomic, assign) float colorAlpha;
@property (nonatomic, copy) NSString *imageFile;

@end

NS_ASSUME_NONNULL_END
