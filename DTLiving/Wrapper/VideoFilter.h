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

NS_ASSUME_NONNULL_BEGIN

@interface VideoFilter : NSObject

- (instancetype)initWithName:(NSString *)name;
- (NSString *)vertexShaderFile;
- (NSString *)fragmentShaderFile;

@end

NS_ASSUME_NONNULL_END
