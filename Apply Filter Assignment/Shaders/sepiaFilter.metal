//
//  sepiaFilter.metal
//  Apply Filter Assignment
//
//  Created by Ehtisham Badar on 12/08/2023.
//

#include <metal_stdlib>
using namespace metal;

kernel void applySepiaFilter(texture2d<float, access::read> inTexture [[texture(0)]],
                              texture2d<float, access::write> outTexture [[texture(1)]],
                              uint2 gid [[thread_position_in_grid]]) {
    float4 color = inTexture.read(gid);
    float3 sepiaColor = float3(0.272, 0.534, 0.131);
    float3 sepiaFiltered = color.rgb * sepiaColor;
    float3 filteredColor = mix(color.rgb, sepiaFiltered, 0.7); // Adjust intensity as needed
    outTexture.write(float4(filteredColor, color.a), gid);
}
