varying highp vec2 v_texcoord;

uniform sampler2D u_texture;
uniform lowp mat4 u_colorMatrix;
uniform lowp float u_intensity;

void main() {
    lowp vec4 textureColor = texture2D(u_texture, v_texcoord);
    lowp vec4 outputColor = textureColor * u_colorMatrix;

    gl_FragColor = (u_intensity * outputColor) + ((1.0 - u_intensity) * textureColor);
}
