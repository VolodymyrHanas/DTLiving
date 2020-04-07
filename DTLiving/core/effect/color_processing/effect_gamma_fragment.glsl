varying highp vec2 v_texcoord;

uniform sampler2D u_texture;
uniform lowp float u_gamma;

void main() {
    lowp vec4 textureColor = texture2D(u_texture, v_texcoord);
    
    gl_FragColor = vec4(pow(textureColor.rgb, vec3(u_gamma)), textureColor.a);
}
