//
//  VideoTransformFilter.m
//  DTLiving
//
//  Created by Dan Jiang on 2020/4/13.
//  Copyright © 2020 Dan Thought Studio. All rights reserved.
//

#import "VideoTransformFilter.h"

@implementation VideoTransformFilter

- (instancetype)init {
    self = [super initWithName:kVideoTransformEffect];
    if (self) {
        self.transform3D = CATransform3DIdentity;
    }
    return self;
}

- (void)setAffineTransform:(CGAffineTransform)newValue {
    self.transform3D = CATransform3DMakeAffineTransform(newValue);
}

- (CGAffineTransform)affineTransform {
    return CATransform3DGetAffineTransform(self.transform3D);
}

- (NSString *)vertexShaderFile {
    return [NSString stringWithFormat:@"%@_vertex", self.name];
}

- (NSString *)fragmentShaderFile {
    return @"effect_fragment";
}

- (NSDictionary<NSString*, NSArray<NSNumber*>*> *)floatParams {
    NSArray<NSNumber*> *transformMatrix = [self convert3DTransformToArray:self.transform3D];
    return @{[NSString stringWithUTF8String:kVideoTransformEffectModelMatrix]: transformMatrix};
}

- (NSArray<NSNumber*> *)convert3DTransformToArray:(CATransform3D)transform3D {
    return @[@(transform3D.m11), @(transform3D.m12), @(transform3D.m13), @(transform3D.m14),
             @(transform3D.m21), @(transform3D.m22), @(transform3D.m23), @(transform3D.m24),
             @(transform3D.m31), @(transform3D.m32), @(transform3D.m33), @(transform3D.m34),
             @(transform3D.m41), @(transform3D.m42), @(transform3D.m43), @(transform3D.m44)];
}

@end
