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

static const char *kVideoBrightnessEffect = "effect_brightness";
static const char *kVideoBrightnessEffectBrightness = "u_brightness"; // -1.0 ~ 1.0

static const char *kVideoExposureEffect = "effect_exposure";
static const char *kVideoExposureEffectExposure = "u_exposure"; // -10.0 ~ 10.0

static const char *kVideoContrastEffect = "effect_contrast";
static const char *kVideoContrastEffectContrast = "u_contrast"; // 0.0 ~ 4.0

static const char *kVideoSaturationEffect = "effect_saturation";
static const char *kVideoSaturationEffectSaturation = "u_saturation"; // 0.0 ~ 2.0

static const char *kVideoGammaEffect = "effect_gamma";
static const char *kVideoGammaEffectGamma = "u_gamma"; // 0.0 ~ 3.0

static const char *kVideoLevelsEffect = "effect_levels";
static const char *kVideoLevelsEffectLevelMinimum = "u_levelMinimum"; // 0.0 ~ 1.0
static const char *kVideoLevelsEffectLevelMiddle = "u_levelMiddle"; // 0.0 ~ 1.0
static const char *kVideoLevelsEffectLevelMaximum = "u_levelMaximum"; // 0.0 ~ 1.0
static const char *kVideoLevelsEffectMinOutput = "u_minOutput"; // 0.0 ~ 1.0
static const char *kVideoLevelsEffectMaxOutput = "u_maxOutput"; // 0.0 ~ 1.0

static const char *kVideoColorMatrixEffect = "effect_color_matrix";
static const char *kVideoColorMatrixEffectColorMatrix = "u_colorMatrix"; // 4x4
static const char *kVideoColorMatrixEffectIntensity = "u_intensity"; // 0.0 ~ 1.0

static const char *kVideoRGBEffect = "effect_rgb";
static const char *kVideoRGBEffectRed = "u_redAdjustment"; // 0.0 ~ 1.0
static const char *kVideoRGBEffectGreen = "u_greenAdjustment"; // 0.0 ~ 1.0
static const char *kVideoRGBEffectBlue = "u_blueAdjustment"; // 0.0 ~ 1.0

static const char *kVideoHueEffect = "effect_hue";
static const char *kVideoHueEffectHue = "u_hueAdjust"; // 0.0 ~ 3.0

static const char *kVideoGrayScaleEffect = "effect_gray_scale";

#endif /* constants_h */
