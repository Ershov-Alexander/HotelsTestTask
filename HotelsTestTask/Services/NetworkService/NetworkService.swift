//
//  NetworkHandler2.swift
//  HotelsTestTask
//
//  Created by Alexander Ershov on 01.12.2019.
//  Copyright © 2019 Alexander Ershov. All rights reserved.
//

import Foundation
import Alamofire


/// Makes request to the server to get hotel data
protocol NetworkServiceProtocol {
    var hotelUrl: HotelUrlProtocol { get set }
    
    /// Cancels requests if needed
    func cancelRequest()
    
    /// Makes request for basic hotel info
    /// - Parameter completionHandler: Invokes when request completed
    func makeRequestForBasicInfo(completionHandler: @escaping (Result<[DecodableBasicHotelInfo], NetworkServiceError>) -> Void)
    
    /// Makes request for full hotel info
    /// - Parameters:
    ///   - id: hotel id
    ///   - completionHandler: Invokes when request completed
    func makeRequestForFullInfo(with id: Int, completionHandler: @escaping (Result<DecodableFullHotelInfo, NetworkServiceError>) -> Void)
    
    /// Makes request for hotel image
    /// - Parameters:
    ///   - id: image id
    ///   - completionHandler: Invokes when request completed
    func makeRequestForImage(with id: Int, completionHandler: @escaping (Result<Data, NetworkServiceError>) -> Void)
}

class NetworkService: NetworkServiceProtocol {
    private var dataRequest: DataRequest?
    private var downloadRequest: DownloadRequest?
    
    var hotelUrl: HotelUrlProtocol = HotelUrl()

    func makeRequestForBasicInfo(completionHandler: @escaping (Result<[DecodableBasicHotelInfo], NetworkServiceError>) -> Void) {
        let url = hotelUrl.getUrl(for: .basicHotels)
        makeRequestForDecodable(for: url, completionHandler: completionHandler)
    }

    func makeRequestForFullInfo(with id: Int, completionHandler: @escaping (Result<DecodableFullHotelInfo, NetworkServiceError>) -> Void) {
        let url = hotelUrl.getUrl(for: .fullHotelInfo(id: id))
        makeRequestForDecodable(for: url, completionHandler: completionHandler)
    }

    func makeRequestForImage(with id: Int, completionHandler: @escaping (Result<Data, NetworkServiceError>) -> Void) {
        downloadRequest?.cancel()
        let url = hotelUrl.getUrl(for: .image(id: id))
        downloadRequest = AF.download(url).validate()
        downloadRequest?.responseData { response in
            let result = response.result.mapError(NetworkService.mapToNetworkHandlerError)
            completionHandler(result)
        }
    }

    func cancelRequest() {
        dataRequest?.cancel()
        downloadRequest?.cancel()
    }

    private func makeRequestForDecodable<T: Decodable>(for endPoint: URL, completionHandler: @escaping (Result<T, NetworkServiceError>) -> Void) {
        dataRequest?.cancel()
        dataRequest = AF.request(endPoint).validate()
        dataRequest?.responseDecodable(of: T.self) { response in
            completionHandler(response.result.mapError(NetworkService.mapToNetworkHandlerError))
        }
    }
    
    private static func mapToNetworkHandlerError(_ afError: AFError) -> NetworkServiceError {
        .networkError(description: afError.localizedDescription)
    }
}

/// Errors that might occur in `NetworkService`
enum NetworkServiceError: LocalizedError {
    case networkError(description: String)
    
    var errorDescription: String? {
        switch self {
        case .networkError(let description):
            return description
        }
    }
}

