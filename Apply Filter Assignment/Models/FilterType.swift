//
//  FilterType.swift
//  Apply Filter Assignment
//
//  Created by Ehtisham Badar on 12/08/2023.
//

import UIKit
import CoreImage

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
