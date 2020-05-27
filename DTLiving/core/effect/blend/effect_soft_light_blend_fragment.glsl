varying highp vec2 v_texcoord;
varying highp vec2 v_texcoord2;

uniform sampler2D u_texture;
uniform sampler2D u_texture2;

const mediump vec3 luminanceWeighting = vec3(0.2125, 0.7154, 0.0721);

void main() {
    mediump vec4 base = texture2D(u_texture, v_texcoord);
    mediump vec4 overlay = texture2D(u_texture2, v_texcoord2);
    mediump float luminance = dot(overlay.rgb, luminanceWeighting);
        
    if (luminance <= 0.5) {
        gl_FragColor = (vec4(2) * overlay - vec4(1)) * (base - base * base) + base;
    } else {
        gl_FragColor = (vec4(2) * overlay - vec4(1)) * (sqrt(base) - base) + base;
    }
}
