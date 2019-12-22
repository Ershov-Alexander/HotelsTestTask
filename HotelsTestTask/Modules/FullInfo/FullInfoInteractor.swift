//
//  FullInfoInteractor.swift
//  HotelsTestTask
//
//  Created by Alexander Ershov on 21.12.2019.
//  Copyright © 2019 Alexander Ershov. All rights reserved.
//

import Foundation
import UIKit

/// Interactor for `FullInfo` module
protocol FullInfoInteractorProtocol: class {

    /// Basic hotel info
    var basicHotelInfo: BasicHotelInfoProtocol { get }

    /// Full hotel info
    var fullHotelInfo: FullHotelInfoProtocol? { get }

    /// Hotel image
    var image: UIImage? { get }

    /// `FullInfoInteractorProtocol `delegate
    var delegate: FullInfoInteractorDelegate? { get set }

    /// Downloads full hotel info
    func downloadFullInfo()

    /// Downloads hotel image
    func downloadImage()

    /// Cancels network request if needed
    func cancelNetworkRequest()
}

/// `FullInfoInteractorProtocol `delegate
protocol FullInfoInteractorDelegate: class {

    /// Invokes when full hotel info downloaded successfully
    func fullInfoDownloaded()

    /// Invokes when hotel image downloaded successfully
    func imageDownloaded()

    /// Invokes when an error occurred (while downloading or image processing)
    /// - Parameter error: error that occurred
    func errorOccurred(error: Error)
}

class FullInfoInteractor: FullInfoInteractorProtocol {
    private let networkService: NetworkServiceProtocol
    private let imageService: ImageServiceProtocol

    let basicHotelInfo: BasicHotelInfoProtocol
    private(set) var fullHotelInfo: FullHotelInfoProtocol?
    private(set) var image: UIImage?

    weak var delegate: FullInfoInteractorDelegate?

    init(basicHotelInfo: BasicHotelInfoProtocol,
         networkService: NetworkServiceProtocol = NetworkService(),
         imageService: ImageServiceProtocol = ImageService()) {
        self.networkService = networkService
        self.imageService = imageService
        self.basicHotelInfo = basicHotelInfo
    }

    func downloadFullInfo() {
        networkService.makeRequestForFullInfo(with: basicHotelInfo.id) { [weak self] result in
            guard let self = self else {
                return
            }
            switch result {
            case .success(let hotelInfo):
                self.fullHotelInfo = hotelInfo
                self.delegate?.fullInfoDownloaded()
            case .failure(let error):
                self.delegate?.errorOccurred(error: error)
            }
        }
    }

    func downloadImage() {
        guard let imageId = fullHotelInfo?.image else {
            return
        }
        networkService.makeRequestForImage(with: imageId) { [weak self] result in
            guard let self = self else {
                return
            }
            let mappedResult = result
                    .mapError(self.mapNetworkServiceError)
                    .flatMap {
                        self.imageService.convertDataToImage($0)
                        .flatMap { imageToCrop in
                            self.imageService.cropImage(imageToCrop, numberOfPixels: 1)
                        }
                        .mapError(self.mapImageServiceError)
                    }
            switch mappedResult {
            case .success(let image):
                self.image = image
                self.delegate?.imageDownloaded()
            case .failure(let error):
                self.delegate?.errorOccurred(error: error)
            }
        }
    }

    func cancelNetworkRequest() {
        networkService.cancelRequest()
    }

    private func mapNetworkServiceError(_ error: NetworkServiceError) -> FullInfoInteractorError {
        .networkError(description: error.localizedDescription)
    }

    private func mapImageServiceError(_ error: ImageServiceError) -> FullInfoInteractorError {
        .imageError(description: error.localizedDescription)
    }
}

enum FullInfoInteractorError: LocalizedError {
    case networkError(description: String)
    case imageError(description: String)
}
