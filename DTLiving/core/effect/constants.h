//
//  constants.h
//  DTLiving
//
//  Created by Dan Jiang on 2020/3/19.
//  Copyright © 2020 Dan Thought Studio. All rights reserved.
//

#ifndef DTLIVING_EFFECT_CONSTANTS_H_
#define DTLIVING_EFFECT_CONSTANTS_H_

// TODO: Protocol Buffers to auto generate

extern const char *kVideoBrightnessEffect;
extern const char *kVideoBrightnessEffectBrightness; // -1.0 ~ 1.0

extern const char *kVideoExposureEffect;
extern const char *kVideoExposureEffectExposure; // -10.0 ~ 10.0

extern const char *kVideoContrastEffect;
extern const char *kVideoContrastEffectContrast; // 0.0 ~ 4.0

extern const char *kVideoSaturationEffect;
extern const char *kVideoSaturationEffectSaturation; // 0.0 ~ 2.0

extern const char *kVideoGammaEffect;
extern const char *kVideoGammaEffectGamma; // 0.0 ~ 3.0

extern const char *kVideoLevelsEffect;
extern const char *kVideoLevelsEffectLevelMinimum; // 0.0 ~ 1.0
extern const char *kVideoLevelsEffectLevelMiddle; // 0.0 ~ 1.0
extern const char *kVideoLevelsEffectLevelMaximum; // 0.0 ~ 1.0
extern const char *kVideoLevelsEffectMinOutput; // 0.0 ~ 1.0
extern const char *kVideoLevelsEffectMaxOutput; // 0.0 ~ 1.0

extern const char *kVideoColorMatrixEffect;
extern const char *kVideoColorMatrixEffectColorMatrix; // 4x4 matrix
extern const char *kVideoColorMatrixEffectIntensity; // 0.0 ~ 1.0

extern const char *kVideoRGBEffect;
extern const char *kVideoRGBEffectRed; // 0.0 ~ 1.0
extern const char *kVideoRGBEffectGreen; // 0.0 ~ 1.0
extern const char *kVideoRGBEffectBlue; // 0.0 ~ 1.0

extern const char *kVideoHueEffect;
extern const char *kVideoHueEffectHue; // 0.0 ~ 3.0

extern const char *kVideoGrayScaleEffect;

extern const char *kVideoTransformEffect;
extern const char *kVideoTransformEffectModelMatrix;

extern const char *kVideoCropEffect;

extern const char *kVideoGaussianBlurEffect;
extern const char *kVideoGaussianBlurEffectBlurRadiusInPixels;

extern const char *kVideoBoxBlurEffect;
extern const char *kVideoBoxBlurEffectBlurRadiusInPixels;

extern const char *kVideoSobelEdgeDetectionEffect;
extern const char *kVideoSobelEdgeDetectionEffectEdgeStrength;

extern const char *kVideoAddBlendEffect;

extern const char *kVideoAlphaBlendEffect;
extern const char *kVideoAlphaBlendEffectMixturePercent;

extern const char *kVideoMaskEffect;
extern const char *kVideoMaskEffectColor;

extern const char *kVideo3x3ConvolutionEffectConvolutionMatrix;

extern const char *kVideoEmbossEffect;

extern const char *kVideoToonEffect;
extern const char *kVideoToonEffectThreshold; // 0.0 ~ 1.0
extern const char *kVideoToonEffectQuantizationLevels;

extern const char *kVideoSketchEffect;
extern const char *kVideoSketchEffectEdgeStrength;

extern const char *kVideoMosaicEffect;
extern const char *kVideoMosaicEffectInputTileSize;
extern const char *kVideoMosaicEffectDisplayTileSize;
extern const char *kVideoMosaicEffectNumTiles;
extern const char *kVideoMosaicEffectColorOn;

extern const char *kVideoCompositionEffectModelMatrix;

extern const char *kVideoWaterMaskEffect;

extern const char *kVideoAnimatedStickerEffect;
extern const char *kVideoAnimatedStickerEffectInterval;

#endif /* constants_h */
