//
//  VideoFilter.m
//  DTLiving
//
//  Created by Dan Jiang on 2020/3/17.
//  Copyright © 2020 Dan Thought Studio. All rights reserved.
//

#import "VideoFilter.h"

VideoVec3 VideoVec3Make(float x, float y, float z) {
    VideoVec3 vec = { x, y, z };
    return vec;
}

VideoVec4 VideoVec4Make(float x, float y, float z, float w) {
    VideoVec4 vec = { x, y, z, w };
    return vec;
}

VideoMat4 VideoMat4Make(VideoVec4 x, VideoVec4 y, VideoVec4 z, VideoVec4 w) {
    VideoMat4 mat = { x, y, z, w };
    return mat;
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

- (NSDictionary<NSString*, NSArray<NSNumber*>*> *)intParams {
    return [NSDictionary new];
}

- (NSDictionary<NSString*, NSArray<NSNumber*>*> *)floatParams {
    return [NSDictionary new];
}

- (NSArray<NSNumber*> *)vec3ToArray:(VideoVec3)vec {
    return @[@(vec.x), @(vec.y), @(vec.z)];
}

- (NSArray<NSNumber*> *)mat4ToArray:(VideoMat4)mat {
    return @[@(mat.x.x), @(mat.x.y), @(mat.x.z), @(mat.x.w),
             @(mat.y.x), @(mat.y.y), @(mat.y.z), @(mat.y.w),
             @(mat.z.x), @(mat.z.y), @(mat.z.z), @(mat.z.w),
             @(mat.w.x), @(mat.w.y), @(mat.w.z), @(mat.w.w)];
}


@end
