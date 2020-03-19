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

- (void)updateFilter:(VideoFilter *)filter {
    for (NSString *key in filter.params) {
        NSNumber *value = filter.params[key];
        self.processor->SetEffectParamFloat([filter.name UTF8String],
                                            [key UTF8String],
                                            value.floatValue);
    }
}

- (void)processs:(GLuint)inputTexture outputTexture:(GLuint)outputTexture size:(CGSize)size {
    dtliving::opengl::VideoFrame inputFrame { inputTexture, GLsizei(size.width), GLsizei(size.height) };
    dtliving::opengl::VideoFrame outputFrame { outputTexture, GLsizei(size.width), GLsizei(size.height) };
    self.processor->Process(inputFrame, outputFrame);
}

@end
