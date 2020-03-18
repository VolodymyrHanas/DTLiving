//
//  VideoEffectProcessorObject.m
//  DTLiving
//
//  Created by Dan Jiang on 2020/3/12.
//  Copyright © 2020 Dan Thought Studio. All rights reserved.
//

#import "VideoEffectProcessorObject.h"
#import "video_effect_processor.h"

@interface VideoEffectProcessorObject ()

@property (nonatomic, assign) std::shared_ptr<dtliving::opengl::VideoEffectProcessor> processor;

@end

@implementation VideoEffectProcessorObject

- (instancetype)init {
    self = [super init];
    if (self) {
        self.processor = std::make_shared<dtliving::opengl::VideoEffectProcessor>();
    }
    return self;
}

- (void)addFilter:(VideoFilter *)filter {
    self.processor->AddEffect([filter.name UTF8String],
                              [[filter vertexShaderFile] UTF8String],
                              [[filter fragmentShaderFile] UTF8String]);
}

- (void)processs:(GLuint)inputTexture outputTexture:(GLuint)outputTexture {
    self.processor->Process(inputTexture, outputTexture);
}

@end
