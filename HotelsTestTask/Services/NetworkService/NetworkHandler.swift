//
//  NetworkHandler2.swift
//  HotelsTestTask
//
//  Created by Alexander Ershov on 01.12.2019.
//  Copyright © 2019 Alexander Ershov. All rights reserved.
//

import Foundation
import UIKit

import Alamofire

/// Makes requests for getting hotel data
class NetworkHandler {
    // MARK: - Variables
    private var dataRequest: DataRequest?
    private var downloadRequest: DownloadRequest?

    // MARK: - Public API
    /// Makes request for getting basic hotel info
    /// - Parameter completionHandler: Invokes when request completed
    func makeRequestForBasicInfo(completionHandler: @escaping (Result<[DecodableBasicHotelInfo], NetworkHandlerError>) -> Void) {
        makeRequestForDecodable(for: HotelEndPoints.basicHotels.url, completionHandler: completionHandler)
    }

    /// Makes request for full hotel info
    /// - Parameters:
    ///   - id: Hotel id
    ///   - completionHandler: Invokes when request completed
    func makeRequestForFullInfo(with id: Int, completionHandler: @escaping (Result<DecodableFullHotelInfo, NetworkHandlerError>) -> Void) {
        makeRequestForDecodable(for: HotelEndPoints.fullHotelInfo(id: id).url, completionHandler: completionHandler)
    }

    /// Makes request for hotel image
    /// - Parameters:
    ///   - id: Image id
    ///   - completionHandler: Invokes when request completed
    func makeRequestForImage(with id: Int, completionHandler: @escaping (Result<UIImage, NetworkHandlerError>) -> Void) {
        downloadRequest?.cancel()
        downloadRequest = AF.download(HotelEndPoints.image(id: id).url).validate()
        downloadRequest?.responseData { response in
            let result = response.result
                .mapError(NetworkHandler.mapToNetworkHandlerError)
                .flatMap(NetworkHandler.convertDataToUIImage)
            completionHandler(result)
        }
    }

    /// Cancels request if it's in progress
    func cancelRequest() {
        dataRequest?.cancel()
        downloadRequest?.cancel()
    }

    // MARK: - Utility functions
    private func makeRequestForDecodable<T: Decodable>(for endPoint: URL, completionHandler: @escaping (Result<T, NetworkHandlerError>) -> Void) {
        dataRequest?.cancel()
        dataRequest = AF.request(endPoint).validate()
        dataRequest?.responseDecodable(of: T.self) { response in
            completionHandler(response.result.mapError(NetworkHandler.mapToNetworkHandlerError))
        }
    }
    
    private static func convertDataToUIImage(_ data: Data) -> Result<UIImage, NetworkHandlerError> {
        if let image = UIImage(data: data) {
            return .success(image)
        } else {
            return .failure(.notAnImage)
        }
    }
    
    private static func mapToNetworkHandlerError(_ afError: AFError) -> NetworkHandlerError {
        .networkError(description: afError.localizedDescription)
    }
}

// MARK: Supporting enums

/// Errors that might occur in `NetworkHandler`
enum NetworkHandlerError: LocalizedError {
    case notAnImage
    case networkError(description: String)
    
    var errorDescription: String? {
        switch self {
        case .notAnImage:
            return "Provided data can't be converted to an image"
        case .networkError(let description):
            return description
        }
    }
}

/// API end points
enum HotelEndPoints {
    case basicHotels
    case fullHotelInfo(id: Int)
    case image(id: Int)

    var url: URL {
        let baseUrl = "https://raw.githubusercontent.com/Ershov-Alexander/HotelsTestTask/master/HotelFiles/"
        switch self {
        case .basicHotels:
            return URL(string: "\(baseUrl)0777.json")!
        case .fullHotelInfo(let id):
            return URL(string: "\(baseUrl)\(id).json")!
        case .image(let id):
            return URL(string: "\(baseUrl)\(id).jpg")!
        }
    }
}
