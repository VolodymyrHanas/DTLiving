varying highp vec2 v_texcoord;
varying highp vec2 v_texcoord2;

uniform sampler2D u_texture;
uniform sampler2D u_texture2;

void main() {
    lowp vec4 base = texture2D(u_texture, v_texcoord);
    lowp vec4 overlay = texture2D(u_texture2, v_texcoord2);
    
    mediump float r;
    if (overlay.r * base.a + base.r * overlay.a >= overlay.a * base.a) {
        r = overlay.a * base.a + overlay.r * (1.0 - base.a) + base.r * (1.0 - overlay.a);
    } else {
        r = overlay.r + base.r;
    }
    
    mediump float g;
    if (overlay.g * base.a + base.g * overlay.a >= overlay.a * base.a) {
        g = overlay.a * base.a + overlay.g * (1.0 - base.a) + base.g * (1.0 - overlay.a);
    } else {
        g = overlay.g + base.g;
    }
    
    mediump float b;
    if (overlay.b * base.a + base.b * overlay.a >= overlay.a * base.a) {
        b = overlay.a * base.a + overlay.b * (1.0 - base.a) + base.b * (1.0 - overlay.a);
    } else {
        b = overlay.b + base.b;
    }
    
    mediump float a = overlay.a + base.a - overlay.a * base.a;
    
    gl_FragColor = vec4(r, g, b, a);
}
