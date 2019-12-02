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
    private var request: DataRequest?
    
    // MARK: - Public API
    /// Makes request for getting basic hotel info
    /// - Parameter completionHandler: Invokes when request completed. Takes two optionals: error description and data in `[BasicHotelInfo]` format. Only one optional is defined.
    func makeRequestForBasicInfo(completionHandler: @escaping (String?, [BasicHotelInfo]?) -> Void) {
        makeRequest(for: .basicHotels, decoder: decodeJson, completionHandler: completionHandler)
    }
    
    /// Makes request for full hotel info
    /// - Parameters:
    ///   - id: Hotel id
    ///   - completionHandler: Invokes when request completed. Takes two optionals: error description and data in `FullHotelInfo` format. Only one optional is defined.
    func makeRequestForFullInfo(with id: Int, completionHandler: @escaping (String?, FullHotelInfo?) -> Void) {
        makeRequest(for: .fullHotelInfo(id: id), decoder: decodeJson, completionHandler: completionHandler)
    }
    
    /// Makes request for hotel image
    /// - Parameters:
    ///   - id: Image id
    ///   - completionHandler: Invokes when request completed. Takes two optionals: error description and data in `UIImage` format. Only one optional is defined.
    func makeRequestForImage(with id: Int, completionHandler: @escaping (String?, UIImage?) -> Void) {
        makeRequest(for: .image(id: id), decoder: { UIImage(data: $0) }, completionHandler: completionHandler)
    }
    
    /// Cancels request if it's in progress
    func cancelRequest() {
        request?.cancel()
    }
    
    // MARK: - Utility functions
    private func makeRequest<T>(for endPoint: HotelEndPoints, decoder: @escaping (Data) -> T?, completionHandler: @escaping (String?, T?) -> Void) {
        request?.cancel()
        request = Alamofire.request(endPoint.url)
        request?.responseData { response in
            switch response.result {
            case .failure(let error):
                completionHandler(error.localizedDescription, nil)
            case .success(let data):
                if let decodedData = decoder(data) {
                    completionHandler(nil, decodedData)
                } else {
                    completionHandler("Server sent incorrect data", nil)
                }
            }
        }
    }
    
    private func decodeJson<T: Decodable>(_ data: Data) -> T? {
        try? JSONDecoder().decode(T.self, from: data)
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
