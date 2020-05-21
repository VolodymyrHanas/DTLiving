//
//  VideoAnimatedStickerFilter.h
//  DTLiving
//
//  Created by Dan Jiang on 2020/5/20.
//  Copyright © 2020 Dan Thought Studio. All rights reserved.
//

#import "VideoFilter.h"

NS_ASSUME_NONNULL_BEGIN

@interface VideoAnimatedStickerFilter : VideoFilter

@property (nonatomic, copy) NSString *imageName;
@property (nonatomic, assign) int imageCount;
@property (nonatomic, assign) float imageInterval;
@property (nonatomic, assign) float animateDuration;
@property (nonatomic, assign) BOOL isRepeat; // TODO: Handle Repeat
@property (nonatomic, assign) float startScale;
@property (nonatomic, assign) float endScale;
@property (nonatomic, assign) float startRotate; // unit: degree, positive: clockwise, negative: counterclockwise
@property (nonatomic, assign) float endRotate;
@property (nonatomic, assign) VideoVec2 startTranslate; // origin at bottom left
@property (nonatomic, assign) VideoVec2 endTranslate;

- (instancetype)init;

@end

NS_ASSUME_NONNULL_END
