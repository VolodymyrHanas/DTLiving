varying highp vec2 v_texcoord;

uniform sampler2D u_texture;
uniform lowp float u_exposure;

void main() {
    lowp vec4 textureColor = texture2D(u_texture, v_texcoord);
    
    gl_FragColor = vec4((textureColor.rgb * pow(2.0, u_exposure)), textureColor.a);
}
