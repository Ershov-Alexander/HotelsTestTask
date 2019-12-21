//
//  ImageService.swift
//  HotelsTestTask
//
//  Created by Alexander Ershov on 20.12.2019.
//  Copyright © 2019 Alexander Ershov. All rights reserved.
//

import Foundation
import UIKit

/// Provides function to operate with images
protocol ImageServiceProtocol {
    
    /// Convert data to UIImage if possible, otherwise returns error
    /// - Parameter data: data to convert to an image
    func convertDataToImage(_ data: Data) -> Result<UIImage, ImageServiceError>
    
    /// Crops image by 1 px if possible, otherwise returns error
    /// - Parameter image: image to crop
    func cropImage(_ image: UIImage) -> Result<UIImage, ImageServiceError>
}

class ImageService: ImageServiceProtocol {
    func convertDataToImage(_ data: Data) -> Result<UIImage, ImageServiceError> {
        if let image = UIImage(data: data) {
            return .success(image)
        } else {
            return .failure(.failedToCropImage)
        }
    }
    
    func cropImage(_ image: UIImage) -> Result<UIImage, ImageServiceError> {
        let onePixel = 1.0 / image.scale
        let rectToCrop = CGRect(
                origin: CGPoint(x: onePixel, y: onePixel),
                size: CGSize(width: image.size.width - 2 * onePixel, height: image.size.height - 2 * onePixel)
        )
        guard let croppedCGImage = image.cgImage?.cropping(to: rectToCrop) else {
            return .failure(.failedToCropImage)
        }
        let uiImage = UIImage(cgImage: croppedCGImage)
        return .success(uiImage)
    }
}

/// Emage service errors
enum ImageServiceError: LocalizedError {
    case failedToConvertDataToImage
    case failedToCropImage
    
    var errorDescription: String? {
        switch self {
        case .failedToConvertDataToImage:
            return "Failed to convert provided data to image"
        case .failedToCropImage:
            return "Failed to crop provided image"
        }
    }
}
