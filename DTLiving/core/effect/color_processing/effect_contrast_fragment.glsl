varying highp vec2 v_texcoord;

uniform sampler2D u_texture;
uniform lowp float u_contrast;

void main() {
    lowp vec4 textureColor = texture2D(u_texture, v_texcoord);
    
    gl_FragColor = vec4(((textureColor.rgb - vec3(0.5)) * u_contrast + vec3(0.5)), textureColor.a);
}
