//
//  NetworkHandler2.swift
//  HotelsTestTask
//
//  Created by Alexander Ershov on 01.12.2019.
//  Copyright © 2019 Alexander Ershov. All rights reserved.
//

import Foundation
import UIKit

class NetworkHandler {
    
    private var dataTask: URLSessionDataTask?
    
    func makeRequestForBasicInfo(completionHandler: @escaping (String?, [BasicHotelInfo]?) -> Void) {
        makeRequest(for: .basicHotels, decoder: decodeJson, completionHandler: completionHandler)
    }
    
    func makeRequestForFullInfo(with id: Int, completionHandler: @escaping (String?, FullHotelInfo?) -> Void) {
        makeRequest(for: .fullHotelInfo(id: id), decoder: decodeJson, completionHandler: completionHandler)
    }
    
    func makeRequestForImage(with id: Int, completionHandler: @escaping (String?, UIImage?) -> Void) {
        makeRequest(for: .image(id: id), decoder: { UIImage(data: $0) }, completionHandler: completionHandler)
    }
    
    func cancelRequest() {
        dataTask?.cancel()
    }
    
    private func makeRequest<T>(for endPoint: HotelEndPoints, decoder: @escaping (Data) -> T?, completionHandler: @escaping (String?, T?) -> Void) {
        dataTask?.cancel()
        dataTask = URLSession.shared.dataTask(with: endPoint.url) { data, response, error in
            if let error = error {
                completionHandler(error.localizedDescription, nil)
                return
            }
            guard let httpResponse = response as? HTTPURLResponse,
                (200...299).contains(httpResponse.statusCode) else {
                    completionHandler("Error on the server side", nil)
                return
            }
            guard let data = data, let decodedData = decoder(data) else {
                completionHandler("Incorrect data in the response", nil)
                return
            }
            completionHandler(nil, decodedData)
        }
        dataTask?.resume()
    }
    
    private func decodeJson<T: Decodable>(_ data: Data) -> T? {
        try? JSONDecoder().decode(T.self, from: data)
    }
    
    private enum HotelEndPoints {
        case basicHotels
        case fullHotelInfo(id: Int)
        case image(id: Int)

        var url: URL {
            switch self {
            case .basicHotels:
                return URL(string: "https://raw.githubusercontent.com/iMofas/ios-android-test/master/0777.json")!
            case .fullHotelInfo(let id):
                return URL(string: "https://raw.githubusercontent.com/iMofas/ios-android-test/master/\(id).json")!
            case .image(let id):
                return URL(string: "https://github.com/iMofas/ios-android-test/raw/master/\(id).jpg")!
            }
        }
    }
}
