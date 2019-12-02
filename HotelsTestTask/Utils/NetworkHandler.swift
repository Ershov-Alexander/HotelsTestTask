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
    /// - Parameter completionHandler: Invokes when request completed. Takes two optionals: error description and data in `[BasicHotelInfo]` format. Only one optional is defined.
    func makeRequestForBasicInfo(completionHandler: @escaping (String?, [BasicHotelInfo]?) -> Void) {
        makeRequestForDecodable(for: .basicHotels, completionHandler: completionHandler)
    }

    /// Makes request for full hotel info
    /// - Parameters:
    ///   - id: Hotel id
    ///   - completionHandler: Invokes when request completed. Takes two optionals: error description and data in `FullHotelInfo` format. Only one optional is defined.
    func makeRequestForFullInfo(with id: Int, completionHandler: @escaping (String?, FullHotelInfo?) -> Void) {
        makeRequestForDecodable(for: .fullHotelInfo(id: id), completionHandler: completionHandler)
    }

    /// Makes request for hotel image
    /// - Parameters:
    ///   - id: Image id
    ///   - completionHandler: Invokes when request completed. Takes two optionals: error description and data in `UIImage` format. Only one optional is defined.
    func makeRequestForImage(with id: Int, completionHandler: @escaping (String?, UIImage?) -> Void) {
        downloadRequest?.cancel()
        downloadRequest = AF.download(HotelEndPoints.image(id: id).url).validate()
        downloadRequest?.responseData { response in
            switch response.result {
            case .failure(let error):
                completionHandler(error.localizedDescription, nil)
            case .success(let data):
                if let image = UIImage(data: data) {
                    completionHandler(nil, image)
                } else {
                    completionHandler("Server sent data that is not an image", nil)
                }
            }
        }
    }

    /// Cancels request if it's in progress
    func cancelRequest() {
        dataRequest?.cancel()
        downloadRequest?.cancel()
    }

    // MARK: - Utility functions
    private func makeRequestForDecodable<T: Decodable>(for endPoint: HotelEndPoints, completionHandler: @escaping (String?, T?) -> Void) {
        dataRequest?.cancel()
        dataRequest = AF.request(endPoint.url).validate()
        dataRequest?.responseDecodable(of: T.self) { response in
            switch response.result {
            case .failure(let error):
                completionHandler(error.localizedDescription, nil)
            case .success(let data):
                completionHandler(nil, data)
            }
        }
    }

    // MARK: - API end points
    /// API end points
    private enum HotelEndPoints {
        case basicHotels
        case fullHotelInfo(id: Int)
        case image(id: Int)

        var url: URL {
            switch self {
            case .basicHotels:
                return URL(string: "https://raw.githubusercontent.com/Ershov-Alexander/HotelsTestTask/master/HotelFiles/0777.json")!
            case .fullHotelInfo(let id):
                return URL(string: "https://raw.githubusercontent.com/Ershov-Alexander/HotelsTestTask/master/HotelFiles/\(id).json")!
            case .image(let id):
                return URL(string: "https://raw.githubusercontent.com/Ershov-Alexander/HotelsTestTask/master/HotelFiles/\(id).jpg")!
            }
        }
    }
}
