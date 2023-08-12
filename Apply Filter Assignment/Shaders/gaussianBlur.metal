//
//  gaussianBlur.metal
//  Apply Filter Assignment
//
//  Created by Ehtisham Badar on 12/08/2023.
//

#include <metal_stdlib>

using namespace metal;

fragment float4 gaussianBlurFragment(texture2d<float> inTexture [[texture(0)]],
                                     sampler inSampler [[sampler(0)]],
                                     constant float &pixelSize [[buffer(0)]],
                                     float2 texCoord [[stage_in]]
                                     ) {
    constexpr int radius = 5;
    float4 color = float4(0.0, 0.0, 0.0, 0.0);

    for (int i = -radius; i <= radius; i++) {
        for (int j = -radius; j <= radius; j++) {
            float2 offset = float2(float(i), float(j)) * pixelSize;
            color += inTexture.sample(inSampler, texCoord + offset);
        }
    }

    return color / ((2.0 * radius + 1.0) * (2.0 * radius + 1.0));
}
