#ifdef GL_ES
precision mediump float;
#endif

uniform float time;

varying vec2 vTexCoord;

void main()
{
    vec2 uv = vTexCoord;
    uv.x += sin(uv.y * 10.0 + time * 5.0) * 0.02;
    gl_FragColor = texture2D( uSampler, uv );
}