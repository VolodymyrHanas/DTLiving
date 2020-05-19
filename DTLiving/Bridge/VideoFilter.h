//
//  VideoFilter.h
//  DTLiving
//
//  Created by Dan Jiang on 2020/3/17.
//  Copyright © 2020 Dan Thought Studio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

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

struct VideoMat3 {
    VideoVec3 x;
    VideoVec3 y;
    VideoVec3 z;
};
typedef struct VideoMat3 VideoMat3;

VideoMat3 VideoMat3Make(VideoVec3 x, VideoVec3 y, VideoVec3 z);

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

typedef NS_ENUM(NSInteger, VideoRotation) {
    VideoRotationNoRotation = 0,
    VideoRotationRotateLeft = 1,
    VideoRotationRotateRight = 2,
    VideoRotationFlipVertical = 3,
    VideoRotationFlipHorizonal = 4,
    VideoRotationRotateRightFlipVertical = 5,
    VideoRotationRotateRightFlipHorizontal = 6,
    VideoRotationRotate180 = 7,
};

BOOL VideoRotationNeedSwapWidthAndHeight(VideoRotation rotation);

@interface VideoFilter : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy, readonly) NSString *vertexShaderFile;
@property (nonatomic, copy, readonly) NSString *fragmentShaderFile;
@property (nonatomic, copy, readonly) NSArray<NSNumber*> *positions;
@property (nonatomic, copy, readonly) NSArray<NSNumber*> *textureCoordinates;
@property (nonatomic, copy, readonly) NSDictionary<NSString*, NSArray<NSNumber*>*> *intParams;
@property (nonatomic, copy, readonly) NSDictionary<NSString*, NSArray<NSNumber*>*> *floatParams;
@property (nonatomic, copy, readonly) NSArray<NSString*> *resources;
@property (nonatomic, assign) float backgroundColorRed;
@property (nonatomic, assign) float backgroundColorGreen;
@property (nonatomic, assign) float backgroundColorBlue;
@property (nonatomic, assign) float backgroundColorAlpha;
@property (nonatomic, assign, readonly) BOOL isRotationAware;
@property (nonatomic, assign) VideoRotation rotation;
@property (nonatomic, assign, readonly) BOOL isSizeAware;
@property (nonatomic, assign) CGSize size;

- (instancetype)initWithName:(const char *)name;

- (NSArray<NSNumber*> *)sizeToArray:(CGSize)size;
- (NSArray<NSNumber*> *)boolToArray:(BOOL)isYES;
- (NSArray<NSNumber*> *)vec3ToArray:(VideoVec3)vec;
- (NSArray<NSNumber*> *)mat3ToArray:(VideoMat3)mat;
- (NSArray<NSNumber*> *)mat4ToArray:(VideoMat4)mat;

@end

NS_ASSUME_NONNULL_END
