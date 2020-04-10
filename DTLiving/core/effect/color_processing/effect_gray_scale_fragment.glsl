varying highp vec2 v_texcoord;

uniform sampler2D u_texture;

const mediump vec3 luminanceWeighting = vec3(0.2125, 0.7154, 0.0721);

void main() {
    lowp vec4 textureColor = texture2D(u_texture, v_texcoord);
    highp float luminance = dot(textureColor.rgb, luminanceWeighting);
    
    gl_FragColor = vec4(vec3(luminance), textureColor.a);
}
