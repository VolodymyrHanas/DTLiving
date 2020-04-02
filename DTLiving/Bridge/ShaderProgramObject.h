//
//  ShaderProgramObject.h
//  DTLiving
//
//  Created by Dan Jiang on 2020/3/13.
//  Copyright © 2020 Dan Thought Studio. All rights reserved.
//

#import <Foundation/Foundation.h>
#include <OpenGLES/ES2/gl.h>
#include <OpenGLES/ES2/glext.h>

NS_ASSUME_NONNULL_BEGIN

@interface ShaderProgramObject : NSObject

- (instancetype)initWithVertexShader:(NSString *)vertexShader fragmentShader:(NSString *)fragmentShader;
- (void)useProgram;
- (void)deleteProgram;
- (GLuint)attributeLocation:(NSString *)name;
- (GLint)uniformLocation:(NSString *)name;

@end

NS_ASSUME_NONNULL_END
