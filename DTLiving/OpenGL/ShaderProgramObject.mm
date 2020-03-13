//
//  ShaderProgramObject.m
//  DTLiving
//
//  Created by Dan Jiang on 2020/3/13.
//  Copyright © 2020 Dan Thought Studio. All rights reserved.
//

#import "ShaderProgramObject.h"
#import "shader_program.h"

@interface ShaderProgramObject ()

@property (nonatomic, assign) std::shared_ptr<ShaderProgram> program;

@end

@implementation ShaderProgramObject

- (instancetype)initWithVertexShader:(NSString *)vertexShader fragmentShader:(NSString *)fragmentShader {
    self = [super init];
    if (self) {
        NSString *vertexShaderFile = [NSBundle.mainBundle pathForResource:vertexShader ofType:@"glsl"];
        NSString *fragmentShaderFile = [NSBundle.mainBundle pathForResource:fragmentShader ofType:@"glsl"];
        self.program = std::make_shared<ShaderProgram>([vertexShaderFile UTF8String], [fragmentShaderFile UTF8String]);
    }
    return self;
}

- (void)useProgram {
    self.program->useProgram();
}

- (void)deleteProgram {
    self.program->deleteProgram();
}

- (GLuint)attributeLocation:(NSString *)name {
    return self.program->attributeLocation([name UTF8String]);
}

- (GLint)uniformLocation:(NSString *)name {
    return self.program->uniformLocation([name UTF8String]);
}

@end
