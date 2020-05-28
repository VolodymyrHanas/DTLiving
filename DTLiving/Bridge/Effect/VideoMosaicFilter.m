//
//  VideoMosaicFilter.m
//  DTLiving
//
//  Created by Dan Jiang on 2020/5/11.
//  Copyright © 2020 Dan Thought Studio. All rights reserved.
//

#import "VideoMosaicFilter.h"

@implementation VideoMosaicFilter

- (instancetype)init {
    self = [super initWithName:kVideoMosaicEffect];
    if (self) {
        self.inputTileSize = CGSizeMake(0.125, 0.125);
        self.displayTileSize = CGSizeMake(0.025, 0.025);
        self.numTiles = 64.0;
        self.colorOn = YES;
    }
    return self;
}

- (void)setInputTileSize:(CGSize)inputTileSize {
    if (inputTileSize.width > 1.0) {
        _inputTileSize.width = 1.0;
    }
    if (inputTileSize.height > 1.0) {
        _inputTileSize.height = 1.0;
    }
    if (inputTileSize.width < 0.0) {
        _inputTileSize.width = 0.0;
    }
    if (inputTileSize.height < 0.0) {
        _inputTileSize.height = 0.0;
    }
        
    _inputTileSize = inputTileSize;
}

-(void)setDisplayTileSize:(CGSize)displayTileSize {
    if (displayTileSize.width > 1.0) {
        _displayTileSize.width = 1.0;
    }
    if (displayTileSize.height > 1.0) {
        _displayTileSize.height = 1.0;
    }
    if (displayTileSize.width < 0.0) {
        _displayTileSize.width = 0.0;
    }
    if (displayTileSize.height < 0.0) {
        _displayTileSize.height = 0.0;
    }
    
    _displayTileSize = displayTileSize;
}

- (NSDictionary<NSString*, NSArray<NSNumber*>*> *)floatParams {
    return @{[NSString stringWithUTF8String:kVideoMosaicEffectInputTileSize]: [self sizeToArray:self.inputTileSize],
             [NSString stringWithUTF8String:kVideoMosaicEffectDisplayTileSize]: [self sizeToArray:self.displayTileSize],
             [NSString stringWithUTF8String:kVideoMosaicEffectNumTiles]: @[@(self.numTiles)]};
}

- (NSDictionary<NSString*,NSArray<NSNumber*>*> *)intParams {
    return @{[NSString stringWithUTF8String:kVideoMosaicEffectColorOn]: [self boolToArray:self.colorOn]};
}

- (NSArray<NSString*> *)resources {
    return @[self.imageName];
}

@end
