attribute vec4 a_position;
attribute vec4 a_texcoord;

const int GAUSSIAN_SAMPLES = 9;

uniform float u_texelWidthOffset;
uniform float u_texelHeightOffset;

varying vec2 v_blurCoordinates[GAUSSIAN_SAMPLES];

void main() {
    gl_Position = a_position;
    
    int multiplier = 0;
    vec2 blurStep;
    vec2 singleStepOffset = vec2(u_texelWidthOffset, u_texelHeightOffset);
    
    for (int i = 0; i < GAUSSIAN_SAMPLES; i++)
    {
        multiplier = (i - ((GAUSSIAN_SAMPLES - 1) / 2));
        blurStep = float(multiplier) * singleStepOffset;
        v_blurCoordinates[i] = a_texcoord.xy + blurStep;
    }
}
