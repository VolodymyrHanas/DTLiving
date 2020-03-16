varying highp vec2 v_texcoord;

uniform sampler2D u_texture;
uniform highp float u_redAdjustment;
uniform highp float u_greenAdjustment;
uniform highp float u_blueAdjustment;

void main() {
    highp vec4 textureColor = texture2D(u_texture, v_texcoord);
    
    gl_FragColor = vec4(textureColor.r * u_redAdjustment, textureColor.g * u_greenAdjustment, textureColor.b * u_blueAdjustment, textureColor.a);
}
