//
//  DecodableBasicHotelInfo.swift
//  HotelsTestTask
//
//  Created by Alexander Ershov on 19.12.2019.
//  Copyright © 2019 Alexander Ershov. All rights reserved.
//

import Foundation

struct DecodableBasicHotelInfo: BasicHotelInfoProtocol {
    let id: Int
    let name: String
    let address: String
    let stars: Double
    let distance: Double
    let suitesAvailability: [Int]
}

/// Decodes data from given JSON (example)
///{
///    "id": 40611,
///    "name": "Belleclaire Hotel",
///    "address": "250 West 77th Street, Manhattan",
///    "stars": 3.0,
///    "distance": 100.0,
///    "suites_availability": "1:44:21:87:99:34"
///}
extension DecodableBasicHotelInfo: Decodable {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        id = try container.decode(Int.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        address = try container.decode(String.self, forKey: .address)
        stars = try container.decode(Double.self, forKey: .stars)
        distance = try container.decode(Double.self, forKey: .distance)
        suitesAvailability = try container.decode(String.self, forKey: .suitesAvailability)
                .split(separator: ":")
                .map {
                    if let suiteNumber = Int($0) {
                        return suiteNumber
                    } else {
                        let errorContext = DecodingError.Context(
                                codingPath: [CodingKeys.suitesAvailability],
                                debugDescription: "\(CodingKeys.suitesAvailability) must be list of integers separated by ':'"
                        )
                        throw DecodingError.dataCorrupted(errorContext)
                    }
                }
        // make sure that strings are not empty
        for (property, key) in [(name, CodingKeys.name), (address, CodingKeys.address)] {
            if property.isEmpty {
                let errorContext = DecodingError.Context(
                        codingPath: [key],
                        debugDescription: "\(key) must be non empty"
                )
                throw DecodingError.dataCorrupted(errorContext)
            }
        }
    }

    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case address
        case stars
        case distance
        case suitesAvailability = "suites_availability"
    }
}
