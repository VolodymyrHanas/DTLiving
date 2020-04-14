attribute vec4 a_position;
attribute vec4 a_texcoord;

uniform mat4 u_transformMatrix;
uniform mat4 u_orthographicMatrix;

varying vec2 v_texcoord;

void main(void) {
    v_texcoord = a_texcoord.xy;
    gl_Position = u_orthographicMatrix * u_transformMatrix * vec4(a_position.xyz, 1.0);
}
