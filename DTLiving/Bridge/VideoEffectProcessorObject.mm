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

@property (nonatomic, assign) std::shared_ptr<dtliving::effect::VideoEffectProcessor> processor;

@end

@implementation VideoEffectProcessorObject

- (instancetype)init {
    self = [super init];
    if (self) {
        self.processor = std::make_shared<dtliving::effect::VideoEffectProcessor>();
        NSString *vertexShaderFile = [NSBundle.mainBundle pathForResource:@"effect_vertex" ofType:@"glsl"];
        NSString *fragmentShaderFile = [NSBundle.mainBundle pathForResource:@"effect_fragment" ofType:@"glsl"];
        self.processor->Init([vertexShaderFile UTF8String], [fragmentShaderFile UTF8String]);
    }
    return self;
}

- (void)addFilter:(VideoFilter *)filter {    
    NSString *vertexShaderFile = [NSBundle.mainBundle pathForResource:[filter vertexShaderFile] ofType:@"glsl"];
    NSString *fragmentShaderFile = [NSBundle.mainBundle pathForResource:[filter fragmentShaderFile] ofType:@"glsl"];
    self.processor->AddEffect([filter.name UTF8String],
                              [vertexShaderFile UTF8String],
                              [fragmentShaderFile UTF8String]);
    self.processor->SetClearColor([filter.name UTF8String],
                                  filter.backgroundColorRed,
                                  filter.backgroundColorGreen,
                                  filter.backgroundColorBlue,
                                  filter.backgroundColorAlpha);
    self.processor->SetIgnoreAspectRatio([filter.name UTF8String],
                                         filter.ignoreAspectRatio);
    [self updateFilter:filter];
}

- (void)updateFilter:(VideoFilter *)filter {
    for (NSString *key in filter.intParams) {
        NSArray<NSNumber*> *values = filter.intParams[key];
        int count = int(values.count);
        GLint ints[count];
        for (int i = 0; i < count; i++) {
            NSNumber *value = values[i];
            ints[i] = value.intValue;
        }
        self.processor->SetEffectParamInt([filter.name UTF8String],
                                          [key UTF8String],
                                          ints);
    }
    for (NSString *key in filter.floatParams) {
        NSArray<NSNumber*> *values = filter.floatParams[key];
        int count = int(values.count);
        GLfloat *floats = new GLfloat[count];
        for (int i = 0; i < count; i++) {
            NSNumber *value = values[i];
            floats[i] = value.floatValue;
        }
        self.processor->SetEffectParamFloat([filter.name UTF8String],
                                            [key UTF8String],
                                            floats);
    }
}

- (void)processs:(GLuint)inputTexture outputTexture:(GLuint)outputTexture size:(CGSize)size {
    dtliving::effect::VideoFrame inputFrame { inputTexture, GLsizei(size.width), GLsizei(size.height) };
    dtliving::effect::VideoFrame outputFrame { outputTexture, GLsizei(size.width), GLsizei(size.height) };
    self.processor->Process(inputFrame, outputFrame);
}

@end
