//
//  VideoMosaicFilter.h
//  DTLiving
//
//  Created by Dan Jiang on 2020/5/11.
//  Copyright © 2020 Dan Thought Studio. All rights reserved.
//

#import "VideoFilter.h"

NS_ASSUME_NONNULL_BEGIN

@interface VideoMosaicFilter : VideoFilter

@property (nonatomic, assign) CGSize inputTileSize;
@property (nonatomic, assign) CGSize displayTileSize;
@property (nonatomic, assign) float numTiles;
@property (nonatomic, assign) BOOL colorOn;
@property (nonatomic, copy) NSString *imageFile;

- (instancetype)init;

@end

NS_ASSUME_NONNULL_END
