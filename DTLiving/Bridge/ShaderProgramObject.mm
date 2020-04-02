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

@property (nonatomic, assign) std::shared_ptr<dtliving::effect::ShaderProgram> program;

@end

@implementation ShaderProgramObject

- (instancetype)initWithVertexShader:(NSString *)vertexShader fragmentShader:(NSString *)fragmentShader {
    self = [super init];
    if (self) {
        NSString *vertexShaderFile = [NSBundle.mainBundle pathForResource:vertexShader ofType:@"glsl"];
        NSString *fragmentShaderFile = [NSBundle.mainBundle pathForResource:fragmentShader ofType:@"glsl"];
        self.program = std::make_shared<dtliving::effect::ShaderProgram>([vertexShaderFile UTF8String], [fragmentShaderFile UTF8String]);
    }
    return self;
}

- (void)useProgram {
    self.program->Use();
}

- (void)deleteProgram {
    self.program->Delete();
}

- (GLuint)attributeLocation:(NSString *)name {
    return self.program->AttributeLocation([name UTF8String]);
}

- (GLint)uniformLocation:(NSString *)name {
    return self.program->UniformLocation([name UTF8String]);
}

@end
