//
//  VideoHardLightFilter.h
//  DTLiving
//
//  Created by Dan Jiang on 2020/5/27.
//  Copyright © 2020 Dan Thought Studio. All rights reserved.
//
//  音视频开发进阶指南：基于 Android 与 iOS 平台的实践 — 9.2.5 图层混合介绍 — 强光混合模式

#import "VideoFilter.h"

NS_ASSUME_NONNULL_BEGIN

@interface VideoHardLightFilter : VideoFilter

@property (nonatomic, copy) NSString *imageName;

- (instancetype)init;

@end

NS_ASSUME_NONNULL_END
