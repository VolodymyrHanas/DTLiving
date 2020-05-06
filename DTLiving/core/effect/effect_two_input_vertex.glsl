attribute vec4 a_position;
attribute vec4 a_texcoord;
attribute vec4 a_texcoord2;

varying vec2 v_texcoord;
varying vec2 v_texcoord2;

void main(void) {
    v_texcoord = a_texcoord.xy;
    v_texcoord2 = a_texcoord2.xy;
    gl_Position = a_position;
}
