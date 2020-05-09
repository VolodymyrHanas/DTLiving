varying highp vec2 v_texcoord;
varying highp vec2 v_texcoord2;

uniform sampler2D u_texture;
uniform sampler2D u_texture2;

uniform lowp float u_mixturePercent;

void main() {
    lowp vec4 textureColor = texture2D(u_texture, v_texcoord);
    lowp vec4 textureColor2 = texture2D(u_texture2, v_texcoord2);
    
    gl_FragColor = vec4(mix(textureColor.rgb, textureColor2.rgb, textureColor2.a * mixturePercent), textureColor.a);
}
