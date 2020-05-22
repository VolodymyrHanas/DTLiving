//
//  VideoAnimatedStickerFilter.m
//  DTLiving
//
//  Created by Dan Jiang on 2020/5/20.
//  Copyright © 2020 Dan Thought Studio. All rights reserved.
//

#import "VideoAnimatedStickerFilter.h"

@implementation VideoAnimatedStickerFilter

- (instancetype)init {
    self = [super initWithName:kVideoAnimatedStickerEffect];
    if (self) {
        self.isRepeat = true;
        self.startScale = 1.0;
        self.endScale = 1.0;
        self.startRotate = 0;
        self.endRotate = 0;
        self.startTranslate = VideoVec2Make(0.0, 0.0);
        self.endTranslate = VideoVec2Make(0.0, 0.0);
    }
    return self;
}

- (NSDictionary<NSString*, NSArray<NSNumber*>*> *)floatParams {
    return @{[NSString stringWithUTF8String:kVideoAnimatedStickerEffectImageInterval]: @[@(self.imageInterval)],
             [NSString stringWithUTF8String:kVideoAnimatedStickerEffectAnimateDuration]: @[@(self.animateDuration)],
             [NSString stringWithUTF8String:kVideoAnimatedStickerEffectStartScale]: @[@(self.startScale)],
             [NSString stringWithUTF8String:kVideoAnimatedStickerEffectEndScale]: @[@(self.endScale)],
             [NSString stringWithUTF8String:kVideoAnimatedStickerEffectStartRotate]: @[@(self.startRotate)],
             [NSString stringWithUTF8String:kVideoAnimatedStickerEffectEndRotate]: @[@(self.endRotate)],
             [NSString stringWithUTF8String:kVideoAnimatedStickerEffectStartTranslate]: [self vec2ToArray:self.startTranslate],
             [NSString stringWithUTF8String:kVideoAnimatedStickerEffectEndTranslate]: [self vec2ToArray:self.endTranslate]};
}

- (NSDictionary<NSString*, NSArray<NSNumber*>*> *)intParams {
    return @{[NSString stringWithUTF8String:kVideoAnimatedStickerEffectIsRepeat]: [self boolToArray:self.isRepeat]};
}

- (NSArray<NSString*> *)resources {
    NSMutableArray<NSString*> *imageNames = [NSMutableArray<NSString*> new];
    int index = 0;
    while (index < self.imageCount) {
        [imageNames addObject:[NSString stringWithFormat:@"%@%02d", self.imageName, index + 1]];
        index++;
    }
    return imageNames;
}

@end
