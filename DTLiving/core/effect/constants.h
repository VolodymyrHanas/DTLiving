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

static const char *kVideoRGBEffect = "effect_rgb";
static const char *kVideoRGBEffectRed = "u_redAdjustment";
static const char *kVideoRGBEffectGreen = "u_greenAdjustment";
static const char *kVideoRGBEffectBlue = "u_blueAdjustment";

#endif /* constants_h */
