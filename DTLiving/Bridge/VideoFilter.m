//
//  VideoFilter.m
//  DTLiving
//
//  Created by Dan Jiang on 2020/3/17.
//  Copyright © 2020 Dan Thought Studio. All rights reserved.
//

#import "VideoFilter.h"

VideoVec2 VideoVec2Make(float x, float y) {
    VideoVec2 vec = { x, y };
    return vec;
}

VideoVec3 VideoVec3Make(float x, float y, float z) {
    VideoVec3 vec = { x, y, z };
    return vec;
}

VideoMat3 VideoMat3Make(VideoVec3 x, VideoVec3 y, VideoVec3 z) {
    VideoMat3 mat = { x, y, z };
    return mat;
}

VideoVec4 VideoVec4Make(float x, float y, float z, float w) {
    VideoVec4 vec = { x, y, z, w };
    return vec;
}

VideoMat4 VideoMat4Make(VideoVec4 x, VideoVec4 y, VideoVec4 z, VideoVec4 w) {
    VideoMat4 mat = { x, y, z, w };
    return mat;
}

BOOL VideoRotationNeedSwapWidthAndHeight(VideoRotation rotation) {
    switch (rotation) {
        case VideoRotationRotateLeft:
            return YES;
        case VideoRotationRotateRight:
            return YES;
        case VideoRotationFlipVertical:
            return YES;
        case VideoRotationFlipHorizonal:
            return YES;
        default:
            return NO;
    }
}

@interface VideoFilter ()

@end

@implementation VideoFilter

- (instancetype)initWithName:(const char *)name {
    self = [super init];
    if (self) {
        self.name = [NSString stringWithCString:name encoding:NSUTF8StringEncoding];
    }
    return self;
}

- (NSString *)vertexShaderFile {
    return @"effect_vertex";
}

- (NSString *)fragmentShaderFile {
    return [NSString stringWithFormat:@"%@_fragment", self.name];
}

- (NSArray<NSNumber*> *)positions {
    return nil;
}

- (NSArray<NSNumber*> *)textureCoordinates {
    return nil;
}

- (NSDictionary<NSString*, NSArray<NSNumber*>*> *)intParams {
    return nil;
}

- (NSDictionary<NSString*, NSArray<NSNumber*>*> *)floatParams {
    return nil;
}

- (NSArray<NSString*> *)resources {
    return nil;
}

- (NSArray<GLKTextureInfo*> *)textures {
    return nil;
}

- (BOOL)isRotationAware {
    return NO;
}

- (BOOL)isSizeAware {
    return NO;
}

- (NSArray<NSNumber*> *)sizeToArray:(CGSize)size {
    return @[@(size.width), @(size.height)];
}

- (NSArray<NSNumber*> *)boolToArray:(BOOL)isYES {
    return @[@(isYES ? 1 : 0)];
}

- (NSArray<NSNumber*> *)vec2ToArray:(VideoVec2)vec {
    return @[@(vec.x), @(vec.y)];
}

- (NSArray<NSNumber*> *)vec3ToArray:(VideoVec3)vec {
    return @[@(vec.x), @(vec.y), @(vec.z)];
}

- (NSArray<NSNumber*> *)vec4ToArray:(VideoVec4)vec {
    return @[@(vec.x), @(vec.y), @(vec.z), @(vec.w)];
}

- (NSArray<NSNumber*> *)mat3ToArray:(VideoMat3)mat {
    return @[@(mat.x.x), @(mat.x.y), @(mat.x.z),
             @(mat.y.x), @(mat.y.y), @(mat.y.z),
             @(mat.z.x), @(mat.z.y), @(mat.z.z)];
}

- (NSArray<NSNumber*> *)mat4ToArray:(VideoMat4)mat {
    return @[@(mat.x.x), @(mat.x.y), @(mat.x.z), @(mat.x.w),
             @(mat.y.x), @(mat.y.y), @(mat.y.z), @(mat.y.w),
             @(mat.z.x), @(mat.z.y), @(mat.z.z), @(mat.z.w),
             @(mat.w.x), @(mat.w.y), @(mat.w.z), @(mat.w.w)];
}

@end
