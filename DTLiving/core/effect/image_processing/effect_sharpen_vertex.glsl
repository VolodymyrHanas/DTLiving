attribute vec4 a_position;
attribute vec4 a_texcoord;

uniform float u_imageWidthFactor;
uniform float u_imageHeightFactor;
uniform float u_sharpness;

varying vec2 v_textureCoordinate;
varying vec2 v_leftTextureCoordinate;
varying vec2 v_rightTextureCoordinate;
varying vec2 v_topTextureCoordinate;
varying vec2 v_bottomTextureCoordinate;

varying float v_centerMultiplier;
varying float v_edgeMultiplier;

void main() {
    gl_Position = a_position;
    
    vec2 widthStep = vec2(u_imageWidthFactor, 0.0);
    vec2 heightStep = vec2(0.0, u_imageHeightFactor);
    
    v_textureCoordinate = a_texcoord.xy;
    v_leftTextureCoordinate = a_texcoord.xy - widthStep;
    v_rightTextureCoordinate = a_texcoord.xy + widthStep;
    v_topTextureCoordinate = a_texcoord.xy + heightStep;
    v_bottomTextureCoordinate = a_texcoord.xy - heightStep;
    
    v_centerMultiplier = 1.0 + 4.0 * u_sharpness;
    v_edgeMultiplier = u_sharpness;
}
