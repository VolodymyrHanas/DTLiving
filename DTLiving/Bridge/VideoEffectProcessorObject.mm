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
    NSDictionary<NSString*, NSArray<NSNumber*>*> *intParams = filter.intParams;
    if (intParams) {
        for (NSString *key in intParams) {
            NSArray<NSNumber*> *values = intParams[key];
            int count = int(values.count);
            GLint ints[count];
            for (int i = 0; i < count; i++) {
                NSNumber *value = values[i];
                ints[i] = value.intValue;
            }
            self.processor->SetEffectParamInt([filter.name UTF8String],
                                              [key UTF8String],
                                              ints,
                                              count);
        }
    }
    NSDictionary<NSString*, NSArray<NSNumber*>*> *floatParams = filter.floatParams;
    if (floatParams) {
        for (NSString *key in floatParams) {
            NSArray<NSNumber*> *values = floatParams[key];
            int count = int(values.count);
            GLfloat floats[count];
            for (int i = 0; i < count; i++) {
                NSNumber *value = values[i];
                floats[i] = value.floatValue;
            }
            self.processor->SetEffectParamFloat([filter.name UTF8String],
                                                [key UTF8String],
                                                floats,
                                                count);
        }
    }
    NSArray<NSNumber*> *positions = filter.positions;
    if (positions) {
        int count = int(positions.count);
        GLfloat *floats = new GLfloat[count];
        for (int i = 0; i < count; i++) {
            NSNumber *value = positions[i];
            floats[i] = value.floatValue;
        }
        self.processor->SetPositions([filter.name UTF8String], floats);
    }
    NSArray<NSNumber*> *textureCoordinates = filter.textureCoordinates;
    if (textureCoordinates) {
        int count = int(textureCoordinates.count);
        GLfloat *floats = new GLfloat[count];
        for (int i = 0; i < count; i++) {
            NSNumber *value = textureCoordinates[i];
            floats[i] = value.floatValue;
        }
        self.processor->SetTextureCoordinates([filter.name UTF8String], floats);
    }
}

- (void)processs:(GLuint)inputTexture outputTexture:(GLuint)outputTexture size:(CGSize)size {
    dtliving::effect::VideoFrame inputFrame { inputTexture, GLsizei(size.width), GLsizei(size.height) };
    dtliving::effect::VideoFrame outputFrame { outputTexture, GLsizei(size.width), GLsizei(size.height) };
    self.processor->Process(inputFrame, outputFrame);
}

@end
