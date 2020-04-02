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

@interface VideoFilter : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy, readonly) NSString *vertexShaderFile;
@property (nonatomic, copy, readonly) NSString *fragmentShaderFile;
@property (nonatomic, copy, readonly) NSDictionary *params;

- (instancetype)initWithName:(NSString *)name;

@end

NS_ASSUME_NONNULL_END
