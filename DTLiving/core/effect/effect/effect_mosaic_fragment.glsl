precision highp float;

varying vec2 v_texcoord;

uniform sampler2D u_texture;
uniform sampler2D u_texture2;

uniform vec2 u_inputTileSize;
uniform vec2 u_displayTileSize;
uniform float u_numTiles;
uniform int u_colorOn;

void main() {
    vec2 xy = v_texcoord;
    xy = xy - mod(xy, u_displayTileSize);
    
    vec4 lumcoeff = vec4(0.299,0.587,0.114,0.0);
    
    vec4 inputColor = texture2D(u_texture, xy);
    float lum = dot(inputColor, lumcoeff);
    lum = 1.0 - lum;
    
    float stepsize = 1.0 / u_numTiles;
    float lumStep = (lum - mod(lum, stepsize)) / stepsize;
 
    float rowStep = 1.0 / u_inputTileSize.x;
    float x = mod(lumStep, rowStep);
    float y = floor(lumStep / rowStep);
    
    vec2 startCoord = vec2(float(x) *  u_inputTileSize.x, float(y) * u_inputTileSize.y);
    vec2 finalCoord = startCoord + ((v_texcoord - xy) * (u_inputTileSize / u_displayTileSize));
    
    vec4 color = texture2D(u_texture2, finalCoord);
    if (u_colorOn == 1) {
        color = color * inputColor;
    }
    
    gl_FragColor = color;
}

