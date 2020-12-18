///textures=1;

#include <metal_stdlib>
using namespace metal;

typedef struct {
    float4 position [[ position ]];
    float2 textureCoordinate;
} VertexOut;

fragment float4 playFragment(VertexOut vertexIn [[ stage_in ]],
                             texture2d<float, access::sample> inputTexture [[ texture(0) ]],
                             sampler textureSampler [[ sampler(0) ]],
                             constant float &time [[ buffer(0) ]])
{
    float2 uv = vertexIn.textureCoordinate;
    float4 color = inputTexture.sample(textureSampler, uv);
    return color;
}
