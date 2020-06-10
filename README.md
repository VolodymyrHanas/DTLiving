## Architecture

![DTLiving Architecture](http://blog.danthought.com/images/dtliving-architecture.png)

The whole video processing is a pipeline. There are three different nodes on pipeline: source node, sink node and process node with input and output. An OpenGL ES texture is passing between nodes. That is wrapped as FrameBuffer.

Key Helper Class:

* [VideoContext](https://github.com/danjiang/DTLiving/blob/master/DTLiving/OpenGL/VideoContext.swift) Create an EAGLContext and DispatchQueue. Connect EAGLContext and DispatchQueue as a pair. All operations about this EAGLContext will be send to this DispatchQueue. This DispatchQueue is a serial queue. That avoid problems caused by concurrent operations on EAGLContext.
* [ShaderProgram](https://github.com/danjiang/DTLiving/blob/master/DTLiving/Bridge/ShaderProgramObject.h) A wrapper of OpenGL ES shader program. Writted in C++. Bridge into Swift use Objective-C.
* [FrameBuffer](https://github.com/danjiang/DTLiving/blob/master/DTLiving/OpenGL/FrameBuffer.swift) Briefly talk. This a wrapper of OpenGL ES texture. Detailly talk. Use a CVPixelBuffer as data source when create a CVOpenGLESTexture. Also create an OpenGL Frame Buffer. Bind OpenGL ES texture with OpenGL ES frame buffer.
* [FrameBufferCache](https://github.com/danjiang/DTLiving/blob/master/DTLiving/OpenGL/FrameBufferCache.swift) Cache FrameBuffer base on texture size.

Node on video processing pipeline:

* [VideoOutput](https://github.com/danjiang/DTLiving/blob/master/DTLiving/Capture/VideoOutput.swift) Video output node. Send texture to multiple targets.
* [VideoInput](https://github.com/danjiang/DTLiving/blob/master/DTLiving/Preview/VideoInput.swift) Video input node. Receive one texture.
* [VideoCamera](https://github.com/danjiang/DTLiving/blob/master/DTLiving/Capture/VideoCamera.swift) Source node. Caputre camera video frame. Turn it into texture. Send out.
* [VideoFilterProcessor](https://github.com/danjiang/DTLiving/blob/master/DTLiving/Effect/VideoFilterProcessor.swift) Process node. Receive one texture. Go through video filters chain. Send Out. 
* [VideoView](https://github.com/danjiang/DTLiving/blob/master/DTLiving/Preview/VideoView.swift) Sink node. Receive one texture. Render on CAEAGLLayer.

## Video Capture

![iOS AVCaptureSession](http://blog.danthought.com/images/ios-avcapturesession.png)

First. Create an AVCaptureSession like above graph. Implement AVCaptureVideoDataOutputSampleBufferDelegate to get camera video data as CMSampleBuffer.

After that. Create an OpenGL ES pipeline to turn video data into OpenGL ES texture. Also with orientation change.

Finally. OpenGL ES render into output texture. Use FrameBuffer to wrap it. Inside FrameBuffer. It also use a CVPixelBuffer as data source when create a CVOpenGLESTexture. But this CVPixelBuffer is empty for right now. Before OpenGL ES render. Use FrameBufferCache to get FrameBuffer. Active FrameBuffer to bind OpenGL ES frame buffer as current frame buffer. When create FrameBuffer, OpenGL ES texture already bind with OpenGL ES frame buffer. So this can guarantee OpenGL ES render into this texture.

## Video Effect

Majorly divide into three parts: VideoFilterProcessor (Swift).
Bridge (Objective-C). Core (C++). Let`s talk about them from bottom to top:

### Core Part Writted in C++

You should understand a video effect: run an OpenGL ES shader program to do image processing. Shader program also have inputs and outputs. Outputs are mainly output texture. Inputs are mainly input texture and other parameters to control shader program.

![DTLiving VideoEffectProcessor](http://blog.danthought.com/images/dtliving-videoeffectprocessor.png)

VideoEffectProcessor is an interface to control video effects. There is a video effects chain inside it. Receive a texture. Go through video effects chain. Send out a texture. Methods to control video effect with a name parameter. Every video effect have an unique name. Use this name to find specific video effect in video effects chain. That lead to an issue of cannot add same video effect more than once. I will solve this issue when I have time. 🙃

![DTLiving VideoEffect](http://blog.danthought.com/images/dtliving-videoeffect.png)

VideoEffect is base class of video effect. Be responsible for loading OpenGL ES shader program, feeding shader program with parameters need to run, actually running shader program. Send out processed texture. Base on characteristics of video effect, there are different subclasses.

Mainly base classes:

* [VideoTwoPassEffect](https://github.com/danjiang/DTLiving/blob/master/DTLiving/core/effect/video_two_pass_effect.h) Run two shader programs.
* [VideoTwoPassTextureSamplingEffect](https://github.com/danjiang/DTLiving/blob/master/DTLiving/core/effect/video_two_pass_texture_sampling_effect.h) Inherited from VideoTwoPassEffect. Run two shader programs. First run with vertically sampling. Second run with horizontally sampling.
* [Video3x3TextureSamplingEffect](https://github.com/danjiang/DTLiving/blob/master/DTLiving/core/effect/video_3x3_texture_sampling_effect.h) Sampling 8 point around center point. Plus center point. Sampling 9 points.
* [Video3x3ConvolutionEffect](https://github.com/danjiang/DTLiving/blob/master/DTLiving/core/effect/video_3x3_convolution_effect.h) Inherited from Video3x3TextureSamplingEffect. Get 3x3 sampling points. Multiply 3x3 matrix. Assignment result to center point. This is convolution.
* [VideoTwoInputEffect](https://github.com/danjiang/DTLiving/blob/master/DTLiving/core/effect/video_two_input_effect.h) Send two textures to one same shader program. Blend two textures on one rectangle.
* [VideoCompositionEffect](https://github.com/danjiang/DTLiving/blob/master/DTLiving/core/effect/video_composition_effect.h) One same shader program run twice. First run with a video texture as input. Second run with an image texture as input. So composite results of two runs. Implement water mark, animated sticker and text drawing.

5 different kinds of subclasses:

* Color Processing
	* [VideoBrightnessEffect](https://github.com/danjiang/DTLiving/blob/master/DTLiving/core/effect/color_processing/video_brightness_effect.h) Adjust brightness.
	* [VideoExposureEffect](https://github.com/danjiang/DTLiving/blob/master/DTLiving/core/effect/color_processing/video_exposure_effect.h) Adjust exposure.
	* [VideoContrastEffect](https://github.com/danjiang/DTLiving/blob/master/DTLiving/core/effect/color_processing/video_contrast_effect.h) Adjust contrast.
	* [VideoSaturationEffect](https://github.com/danjiang/DTLiving/blob/master/DTLiving/core/effect/color_processing/video_saturation_effect.h) Adjust saturation.
	* [VideoGammaEffect](https://github.com/danjiang/DTLiving/blob/master/DTLiving/core/effect/color_processing/video_gamma_effect.h) Adjust gamma.
	* [VideoLevelsEffect](https://github.com/danjiang/DTLiving/blob/master/DTLiving/core/effect/color_processing/video_levels_effect.h) Photoshop-like levels adjustment.
	* [VideoColorMatrixEffect](https://github.com/danjiang/DTLiving/blob/master/DTLiving/core/effect/color_processing/video_color_matrix_effect.h) Color of a pixel is 1x4 column vector. Multiply a 4x4 matrix to get a new color.
	* [VideoSepiaFilter](https://github.com/danjiang/DTLiving/blob/master/DTLiving/Bridge/ColorProcessing/VideoSepiaFilter.h) Use VideoColorMatrixEffect implement a sepia effect.
	* [VideoRGBEffect](https://github.com/danjiang/DTLiving/blob/master/DTLiving/core/effect/color_processing/video_rgb_effect.h) Adjust red, green and blue seperatly.
	* [VideoHueEffect](https://github.com/danjiang/DTLiving/blob/master/DTLiving/core/effect/color_processing/video_hue_effect.h) Adjust hue.
	* [Gray Scale](https://github.com/danjiang/DTLiving/blob/master/DTLiving/core/effect/color_processing/effect_gray_scale_fragment.glsl) Turn into gray.
* Image Processing
	* [VideoTransformEffect](https://github.com/danjiang/DTLiving/blob/master/DTLiving/core/effect/image_processing/video_transform_effect.h) Transform image with scale, rotate and translate. Both 2D and 3D transforms are allowed.
	* [VideoCropFilter](https://github.com/danjiang/DTLiving/blob/master/DTLiving/Bridge/ImageProcessing/VideoCropFilter.h) Crop image. It`s not really crop. Output texture size is not change. Only change visible are of this image.
	* [VideoGaussianBlurEffect](https://github.com/danjiang/DTLiving/blob/master/DTLiving/core/effect/image_processing/video_gaussian_blur_effect.h) Gaussian blur.
	* [VideoBoxBlurEffect](https://github.com/danjiang/DTLiving/blob/master/DTLiving/core/effect/image_processing/video_box_blur_effect.h) Box blur.
	* [VideoSobelEdgeDetectionEffect](https://github.com/danjiang/DTLiving/blob/master/DTLiving/core/effect/image_processing/video_sobel_edge_detection_effect.h) Sobel edge detection.
	* [VideoSharpenEffect](https://github.com/danjiang/DTLiving/blob/master/DTLiving/core/effect/image_processing/video_sharpen_effect.h) Sharpen.
	* [VideoBilateralEffect](https://github.com/danjiang/DTLiving/blob/master/DTLiving/core/effect/image_processing/video_bilateral_effect.h) Bilateral.
* Blend
	* [Add Blend](https://github.com/danjiang/DTLiving/blob/master/DTLiving/core/effect/blend/effect_add_blend_fragment.glsl)
	* [Alpha Blend](https://github.com/danjiang/DTLiving/blob/master/DTLiving/core/effect/blend/video_alpha_blend_effect.h)
	* [VideoMaskEffect](https://github.com/danjiang/DTLiving/blob/master/DTLiving/core/effect/blend/video_mask_effect.h) Provide an image texture as mask for video texture. White will pass. Black will be deleted.
	* [Multiply Blend](https://github.com/danjiang/DTLiving/blob/master/DTLiving/core/effect/blend/effect_multiply_blend_fragment.glsl)
	* [Screen Blend](https://github.com/danjiang/DTLiving/blob/master/DTLiving/core/effect/blend/effect_screen_blend_fragment.glsl)
	* [Overlay Blend](https://github.com/danjiang/DTLiving/blob/master/DTLiving/core/effect/blend/effect_overlay_blend_fragment.glsl)
	* [Soft Light Blend](https://github.com/danjiang/DTLiving/blob/master/DTLiving/core/effect/blend/effect_soft_light_blend_fragment.glsl)
	* [Hard Light Blend](https://github.com/danjiang/DTLiving/blob/master/DTLiving/core/effect/blend/effect_hard_light_blend_fragment.glsl)
* Composition
	* [VideoWaterMaskEffect](https://github.com/danjiang/DTLiving/blob/master/DTLiving/core/effect/composition/video_water_mask_effect.h) Provide an image texture as water mask.
	* [VideoAnimatedStickerEffect](https://github.com/danjiang/DTLiving/blob/master/DTLiving/core/effect/composition/video_animated_sticker_effect.h) Provide a series of images sequence to do animated sticker.
	* [VideoTextEffect](https://github.com/danjiang/DTLiving/blob/master/DTLiving/core/effect/composition/video_text_effect.h) Add text. iOS draw a text into an image. Send it to C++.
* Effect
	* [VideoEmbossFilter](https://github.com/danjiang/DTLiving/blob/master/DTLiving/Bridge/Effect/VideoEmbossFilter.h) Emboss effect.
	* [VideoToonEffect](https://github.com/danjiang/DTLiving/blob/master/DTLiving/core/effect/effect/video_toon_effect.h) Cartoon effect.
	* [VideoSketchEffect](https://github.com/danjiang/DTLiving/blob/master/DTLiving/core/effect/effect/video_sketch_effect.h) Sketch effect.
	* [VideoMosaicEffect](https://github.com/danjiang/DTLiving/blob/master/DTLiving/core/effect/effect/video_mosaic_effect.h) Mosaic effect.

### Bridge Part Writted in Objective-C

One VideoFilter to one VideoEffect. As before said, VideoEffect do heavy work to run shader program. VideoFilter is just data model. VideoEffectProcessorObject contain VideoEffectProcessor. Through VideoEffectProcessorObject, send VideoFilter to core part. This way can control video effects. But have to write a lots of redundant code. The essense is to exchange data between Objective-C layer and C++ layer. So just declare data exchange protocol. Use Protocol Buffers to auto generate codes. I will solve this issue when I have time. 🙃

### VideoFilterProcessor

VideoFilterProcessor is a node on video processing pipeline. Receive one texture. Go through video filters chain. Send Out. VideoFilterProcessor also contain VideoEffectProcessorObject to control video effects.

## Video Preview

Receive one texture. Use OpenGL ES render into CAEAGLLayer. As before said, bind OpenGL ES frame buffer to texture. So it can render into texture. At here, bind OpenGL ES frame buffer to render buffer. Render buffer be connected with CAEAGLLayer. This can guarantee OpenGL ES render into CAEAGLLayer.