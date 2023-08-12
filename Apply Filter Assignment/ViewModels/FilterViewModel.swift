//
//  FilterViewModel.swift
//  Apply Filter Assignment
//
//  Created by Ehtisham Badar on 12/08/2023.
//

import UIKit
import CoreImage
import Metal
import MetalKit

class FilterViewModel {
    enum FilterCategory: String {
        case colorAdjustment = "Color Adjustment"
        case artistic = "Artistic"
    }
    
    enum FilterType: String {
        case sepia = "Sepia"
        case gaussianBlur = "Gaussian Blur"
        case colorInvert = "Color Invert"
        case bloom = "Bloom"
        case vignette = "Vignette"
    }
    
    var filteredImagea: [UIImage] = [UIImage]()
    
    let availableFilters: [FilterType] = [.sepia, .gaussianBlur, .colorInvert, .bloom, .vignette]
    
    let device = MTLCreateSystemDefaultDevice()!
    let metalQueue = DispatchQueue(label: "MetalQueue")
    lazy var library: MTLLibrary = {
        return device.makeDefaultLibrary()!
    }()
    
    lazy var sepiaKernel: MTLFunction = {
        return library.makeFunction(name: "applySepiaFilter")!
    }()
    
    func applyFilter(_ filter: FilterType, to ciImage: CIImage) -> UIImage? {
        // Convert CIImage to a Metal texture
        let ciContext = CIContext(mtlDevice: device)
        guard let cgImage = ciContext.createCGImage(ciImage, from: ciImage.extent),
              let metalTexture = try? MTKTextureLoader(device: device).newTexture(cgImage: cgImage, options: nil) else {
            return nil
        }

        // Create an output texture with appropriate usage flags
        let outputTextureDescriptor = MTLTextureDescriptor.texture2DDescriptor(pixelFormat: metalTexture.pixelFormat,
                                                                               width: metalTexture.width,
                                                                               height: metalTexture.height,
                                                                               mipmapped: false)
        outputTextureDescriptor.usage = [.shaderRead, .shaderWrite] // Set the correct usage flags

        guard let outputTexture = device.makeTexture(descriptor: outputTextureDescriptor) else {
            return nil
        }

        // Create a Metal compute pipeline and encoder for the selected filter kernel
        let kernelFunction: MTLFunction

        switch filter {
        case .sepia:
            kernelFunction = sepiaKernel
        case .gaussianBlur:
            kernelFunction = sepiaKernel
        case .colorInvert:
            kernelFunction = sepiaKernel
        case .bloom:
            kernelFunction = sepiaKernel
        case .vignette:
             kernelFunction = sepiaKernel
        }

        guard let commandQueue = device.makeCommandQueue(),
              let pipeline = try? device.makeComputePipelineState(function: kernelFunction) else {
            return nil
        }

        // Create a command buffer and compute encoder
        let commandBuffer = commandQueue.makeCommandBuffer()
        let computeEncoder = commandBuffer?.makeComputeCommandEncoder()

        // Set the pipeline state and textures
        computeEncoder?.setComputePipelineState(pipeline)
        computeEncoder?.setTexture(metalTexture, index: 0)
        computeEncoder?.setTexture(outputTexture, index: 1)

        // Dispatch the compute kernel
        let threadGroupSize = MTLSizeMake(16, 16, 1)
        let threadGroups = MTLSizeMake(metalTexture.width / threadGroupSize.width,
                                       metalTexture.height / threadGroupSize.height,
                                       1)
        computeEncoder?.dispatchThreadgroups(threadGroups, threadsPerThreadgroup: threadGroupSize)
        computeEncoder?.endEncoding()

        // Convert the output texture to UIImage
        let outputImage = CIImage(mtlTexture: outputTexture, options: nil)
        guard let cgOutputImage = ciContext.createCGImage(outputImage ?? CIImage(), from: outputImage?.extent ?? CGRect()) else {
            return nil
        }

        return UIImage(cgImage: cgOutputImage)
    }


    
    private func applySepiaFilter(to inputImage: CIImage) -> CIImage? {
        let filter = CIFilter(name: "CISepiaTone")!
        filter.setValue(inputImage, forKey: kCIInputImageKey)
        filter.setValue(0.7, forKey: kCIInputIntensityKey)
        return filter.outputImage
    }
    
    private func applyGaussianBlurFilter(to inputImage: CIImage) -> CIImage? {
        let filter = CIFilter(name: "CIGaussianBlur")!
        filter.setValue(inputImage, forKey: kCIInputImageKey)
        filter.setValue(10.0, forKey: kCIInputRadiusKey)
        return filter.outputImage
    }
    
    private func applyColorInvertFilter(to inputImage: CIImage) -> CIImage? {
        let filter = CIFilter(name: "CIColorInvert")!
        filter.setValue(inputImage, forKey: kCIInputImageKey)
        return filter.outputImage
    }
    
    private func applyBloomFilter(to inputImage: CIImage) -> CIImage? {
        let filter = CIFilter(name: "CIBloom")!
        filter.setValue(inputImage, forKey: kCIInputImageKey)
        filter.setValue(0.7, forKey: kCIInputRadiusKey)
        filter.setValue(1.0, forKey: kCIInputIntensityKey)
        return filter.outputImage
    }
    
    private func applyVignetteFilter(to inputImage: CIImage) -> CIImage? {
        let filter = CIFilter(name: "CIVignette")!
        filter.setValue(inputImage, forKey: kCIInputImageKey)
        filter.setValue(0.5, forKey: kCIInputIntensityKey)
        filter.setValue(1.0, forKey: kCIInputRadiusKey)
        return filter.outputImage
    }
    
    func thumbnailImage(for filter: FilterType) -> UIImage? {
        let placeholderImage = UIImage(named: "sourceimage")!
        
        guard let ciImage = CIImage(image: placeholderImage),
              let outputImage = applyFilter(filter, to: ciImage) else {
            return nil
        }
        
        filteredImagea.append(outputImage)
        
        return outputImage
    }
}

