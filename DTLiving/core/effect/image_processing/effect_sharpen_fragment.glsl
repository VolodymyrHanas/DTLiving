precision highp float;

varying highp vec2 v_textureCoordinate;
varying highp vec2 v_leftTextureCoordinate;
varying highp vec2 v_rightTextureCoordinate;
varying highp vec2 v_topTextureCoordinate;
varying highp vec2 v_bottomTextureCoordinate;

varying highp float v_centerMultiplier;
varying highp float v_edgeMultiplier;

uniform sampler2D u_texture;

void main() {
    mediump vec3 textureColor = texture2D(u_texture, v_textureCoordinate).rgb;
    mediump vec3 leftTextureColor = texture2D(u_texture, v_leftTextureCoordinate).rgb;
    mediump vec3 rightTextureColor = texture2D(u_texture, v_rightTextureCoordinate).rgb;
    mediump vec3 topTextureColor = texture2D(u_texture, v_topTextureCoordinate).rgb;
    mediump vec3 bottomTextureColor = texture2D(u_texture, v_bottomTextureCoordinate).rgb;

    gl_FragColor = vec4((textureColor * v_centerMultiplier - (leftTextureColor * v_edgeMultiplier + rightTextureColor * v_edgeMultiplier + topTextureColor * v_edgeMultiplier + bottomTextureColor * v_edgeMultiplier)), texture2D(u_texture, v_bottomTextureCoordinate).w);
}
