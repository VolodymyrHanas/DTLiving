attribute vec4 a_position;
attribute vec4 a_texcoord;

varying vec2 v_texcoord;

void main(void) {
    v_texcoord = a_texcoord.xy;
    gl_Position = a_position;
}
