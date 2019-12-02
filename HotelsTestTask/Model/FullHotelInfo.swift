//
//  Hotels.swift
//  HotelsTestTask
//
//  Created by Alexander Ershov on 30.11.2019.
//  Copyright © 2019 Alexander Ershov. All rights reserved.
//

import Foundation

/// Represents full hotel information
struct FullHotelInfo {
    /// Hotel id
    let id: Int
    /// Hotel name
    let name: String
    /// Hotel address
    let address: String
    /// Number of stars
    let stars: Double
    /// Distance to the centre of a city
    let distance: Double
    /// Image id
    let image: Int
    /// Numbers of available suites
    let suitesAvailability: [Int]
    /// Latitude of hotel location
    let latitude: Double
    /// Longitude of hotel location
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
extension FullHotelInfo: Decodable {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        id = try container.decode(Int.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        address = try container.decode(String.self, forKey: .address)
        stars = try container.decode(Double.self, forKey: .stars)
        distance = try container.decode(Double.self, forKey: .distance)
        let imageStr = try container.decode(String.self, forKey: .image)
        if imageStr.hasSuffix(".jpg"), let imageId = Int(imageStr.components(separatedBy: ".jpg")[0]) {
            image = imageId
        } else {
            throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: [CodingKeys.image], debugDescription: "Image must be in format 'integer_id.jpg'"))
        }
        suitesAvailability = try container.decode(String.self, forKey: .suitesAvailability)
                .split(separator: ":")
                .map {
                    if let suiteNumber = Int($0) {
                        return suiteNumber
                    } else {
                        throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: [CodingKeys.suitesAvailability], debugDescription: "\(CodingKeys.suitesAvailability) must be list of integers separated by ':'"))
                    }
                }
        latitude = try container.decode(Double.self, forKey: .latitude)
        longitude = try container.decode(Double.self, forKey: .longitude)
        // make sure that all strings are not empty
        for (property, key) in [(name, CodingKeys.name), (address, CodingKeys.address)] {
            if property.isEmpty {
                throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: [key], debugDescription: "\(key) must be non empty"))
            }
        }
    }

    private enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case address = "address"
        case stars = "stars"
        case distance = "distance"
        case image = "image"
        case suitesAvailability = "suites_availability"
        case latitude = "lat"
        case longitude = "lon"
    }
}
