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
    
    func applyFilter(_ filter: FilterType, to ciImage: CIImage) -> UIImage? {
        
        var outputImage: CIImage?
        
        switch filter {
        case .sepia:
            outputImage = applySepiaFilter(to: ciImage)
        case .gaussianBlur:
            outputImage = applyGaussianBlurFilter(to: ciImage)
        case .colorInvert:
            outputImage = applyColorInvertFilter(to: ciImage)
        case .bloom:
            outputImage = applyBloomFilter(to: ciImage)
        case .vignette:
            outputImage = applyVignetteFilter(to: ciImage)
        }
        
        guard let filteredImage = outputImage,
              let cgOutputImage = CIContext().createCGImage(filteredImage, from: filteredImage.extent) else {
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

