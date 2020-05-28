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
    const char *name = [filter.name UTF8String];
    NSString *vertexShaderFile = [NSBundle.mainBundle pathForResource:[filter vertexShaderFile] ofType:@"glsl"];
    NSString *fragmentShaderFile = [NSBundle.mainBundle pathForResource:[filter fragmentShaderFile] ofType:@"glsl"];
    self.processor->AddEffect(name, [vertexShaderFile UTF8String], [fragmentShaderFile UTF8String]);
    if (filter.duration > 0) {
        self.processor->SetDuration(name, filter.duration);
    }

    dtliving::effect::vec4 clear_color {
        filter.backgroundColor.x,
        filter.backgroundColor.y,
        filter.backgroundColor.z,
        filter.backgroundColor.w
    };
    self.processor->SetClearColor(name, clear_color);
    if (filter.resources) {
        std::vector<std::string> resources;
        for (NSString *resource in filter.resources) {
            NSString *imageFile = [NSBundle.mainBundle pathForResource:resource ofType:@"png"];
            resources.push_back([imageFile UTF8String]);
        }
        self.processor->LoadResources(name, resources);
    }
    if (filter.textures) {
        std::vector<dtliving::effect::VideoFrame> textures;
        for (GLKTextureInfo *info in filter.textures) {
            dtliving::effect::VideoFrame texture { info.name, GLsizei(info.width), GLsizei(info.height) };
            textures.push_back(texture);
        }
        self.processor->SetTextures(name, textures);
    }
    [self updateFilter:filter];
}

- (void)updateFilter:(VideoFilter *)filter {
    const char *name = [filter.name UTF8String];
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
            self.processor->SetEffectParamInt(name,
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
            self.processor->SetEffectParamFloat(name,
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
        self.processor->SetPositions(name, floats);
    }
    NSArray<NSNumber*> *textureCoordinates = filter.textureCoordinates;
    if (textureCoordinates) {
        int count = int(textureCoordinates.count);
        GLfloat *floats = new GLfloat[count];
        for (int i = 0; i < count; i++) {
            NSNumber *value = textureCoordinates[i];
            floats[i] = value.floatValue;
        }
        self.processor->SetTextureCoordinates(name, floats);
    }
}

- (void)processs:(GLuint)inputTexture outputTexture:(GLuint)outputTexture size:(CGSize)size delta:(double)delta {
    dtliving::effect::VideoFrame inputFrame { inputTexture, GLsizei(size.width), GLsizei(size.height) };
    dtliving::effect::VideoFrame outputFrame { outputTexture, GLsizei(size.width), GLsizei(size.height) };
    self.processor->Process(inputFrame, outputFrame, delta);
}

- (void)clearAllFilters {
    self.processor->ClearAllEffects();
}

@end
