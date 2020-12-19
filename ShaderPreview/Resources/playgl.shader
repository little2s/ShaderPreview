varying vec2 textureCoordinate;

uniform sampler2D inputImageTexture;

uniform float time;

void main()
{
    vec4 color = texture2D(inputImageTexture, textureCoordinate);
    gl_FragColor = color;
}
