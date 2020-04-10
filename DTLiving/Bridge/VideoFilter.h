//
//  VideoFilter.h
//  DTLiving
//
//  Created by Dan Jiang on 2020/3/17.
//  Copyright © 2020 Dan Thought Studio. All rights reserved.
//

#import <Foundation/Foundation.h>
#include <OpenGLES/ES2/gl.h>
#include <OpenGLES/ES2/glext.h>

#include "constants.h"

NS_ASSUME_NONNULL_BEGIN

struct VideoVec3 {
    float x;
    float y;
    float z;
};
typedef struct VideoVec3 VideoVec3;

VideoVec3 VideoVec3Make(float x, float y, float z);

struct VideoVec4 {
    float x;
    float y;
    float z;
    float w;
};
typedef struct VideoVec4 VideoVec4;

VideoVec4 VideoVec4Make(float x, float y, float z, float w);

struct VideoMat4 {
    VideoVec4 x;
    VideoVec4 y;
    VideoVec4 z;
    VideoVec4 w;
};
typedef struct VideoMat4 VideoMat4;

VideoMat4 VideoMat4Make(VideoVec4 x, VideoVec4 y, VideoVec4 z, VideoVec4 w);

@interface VideoFilter : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy, readonly) NSString *vertexShaderFile;
@property (nonatomic, copy, readonly) NSString *fragmentShaderFile;
@property (nonatomic, copy, readonly) NSDictionary<NSString*, NSArray<NSNumber*>*> *intParams;
@property (nonatomic, copy, readonly) NSDictionary<NSString*, NSArray<NSNumber*>*> *floatParams;

- (instancetype)initWithName:(const char *)name;

- (NSArray<NSNumber*> *)vec3ToArray:(VideoVec3)vec;
- (NSArray<NSNumber*> *)mat4ToArray:(VideoMat4)mat;

@end

NS_ASSUME_NONNULL_END
