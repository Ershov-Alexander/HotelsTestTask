//
//  HotelUrl.swift
//  HotelsTestTask
//
//  Created by Alexander Ershov on 21.12.2019.
//  Copyright © 2019 Alexander Ershov. All rights reserved.
//

import Foundation

/// API end points
enum HotelEndPoint {
    case basicHotels
    case fullHotelInfo(id: Int)
    case image(id: Int)
}

/// Gets url to get hotel info data
protocol HotelUrlProtocol {
    func getUrl(for endpoint: HotelEndPoint) -> URL
}

struct HotelUrl: HotelUrlProtocol {
    func getUrl(for endpoint: HotelEndPoint) -> URL {
        let baseUrl = "https://raw.githubusercontent.com/Ershov-Alexander/HotelsTestTask/master/HotelFiles/"
        switch endpoint {
        case .basicHotels:
            return URL(string: "\(baseUrl)0777.json")!
        case .fullHotelInfo(let id):
            return URL(string: "\(baseUrl)\(id).json")!
        case .image(let id):
            return URL(string: "\(baseUrl)\(id).jpg")!
        }
    }
}
