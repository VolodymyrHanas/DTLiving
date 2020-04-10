varying highp vec2 v_texcoord;

uniform sampler2D u_texture;
uniform mediump vec3 u_levelMinimum;
uniform mediump vec3 u_levelMiddle;
uniform mediump vec3 u_levelMaximum;
uniform mediump vec3 u_minOutput;
uniform mediump vec3 u_maxOutput;

mediump vec3 gammaCorrection(mediump vec3 color, mediump vec3 gamma) {
    return pow(color, 1.0 / gamma);
}

mediump vec3 levelsControlInputRange(mediump vec3 color, mediump vec3 minInput, mediump vec3 maxInput) {
    return min(max(color - minInput, vec3(0.0)) / (maxInput - minInput), vec3(1.0));
}

mediump vec3 levelsControlInput(mediump vec3 color, mediump vec3 minInput, mediump vec3 gamma, mediump vec3 maxInput) {
    return gammaCorrection(levelsControlInputRange(color, minInput, maxInput), gamma);
}

mediump vec3 levelsControlOutputRange(mediump vec3 color, mediump vec3 minOutput, mediump vec3 maxOutput) {
    return mix(minOutput, maxOutput, color);
}

mediump vec3 levelsControl(mediump vec3 color, mediump vec3 minInput, mediump vec3 gamma, mediump vec3 maxInput, mediump vec3 minOutput, mediump vec3 maxOutput) {
    return levelsControlOutputRange(levelsControlInput(color, minInput, gamma, maxInput), minOutput, maxOutput);
}

void main() {
    lowp vec4 textureColor = texture2D(u_texture, v_texcoord);
             
    gl_FragColor = vec4(levelsControl(textureColor.rgb, u_levelMinimum, u_levelMiddle, u_levelMaximum, u_minOutput, u_maxOutput), textureColor.a);
}
