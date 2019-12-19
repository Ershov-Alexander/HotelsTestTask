//
//  DecodableFullHotelInfo.swift
//  HotelsTestTask
//
//  Created by Alexander Ershov on 19.12.2019.
//  Copyright © 2019 Alexander Ershov. All rights reserved.
//

import Foundation

struct DecodableFullHotelInfo: FullHotelInfoProtocol {
    let basicHotelInfo: BasicHotelInfoProtocol
    let image: Int
    let latitude: Double
    let longitude: Double
}

/// Decodes data from given JSON (example)
///{
///    "id": 40611,
///    "name": "Belleclaire Hotel",
///    "address": "250 West 77th Street, Manhattan",
///    "stars": 3.0,
///    "distance": 100.0,
///    "image": "1.jpg",
///    "suites_availability": "1:44:21:87:99:34",
///    "lat": 40.78260000000000,
///    "lon": -73.98130000000000
///}
extension DecodableFullHotelInfo: Decodable {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        basicHotelInfo = try DecodableBasicHotelInfo(from: decoder)
        let imageStr = try container.decode(String.self, forKey: .image)
        if imageStr.hasSuffix(".jpg"), let imageId = Int(imageStr.components(separatedBy: ".jpg")[0]) {
            image = imageId
        } else {
            let errorContext = DecodingError.Context(
                    codingPath: [CodingKeys.image],
                    debugDescription: "Image must be in format 'integer_id.jpg'"
            )
            throw DecodingError.dataCorrupted(errorContext)
        }
        latitude = try container.decode(Double.self, forKey: .latitude)
        longitude = try container.decode(Double.self, forKey: .longitude)
    }

    private enum CodingKeys: String, CodingKey {
        case image
        case latitude = "lat"
        case longitude = "lon"
    }
}
