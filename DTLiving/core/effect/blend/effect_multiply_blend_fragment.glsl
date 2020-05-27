varying highp vec2 v_texcoord;
varying highp vec2 v_texcoord2;

uniform sampler2D u_texture;
uniform sampler2D u_texture2;

void main() {
    lowp vec4 base = texture2D(u_texture, v_texcoord);
    lowp vec4 overlay = texture2D(u_texture2, v_texcoord2);
    
    gl_FragColor = base * overlay;
}
