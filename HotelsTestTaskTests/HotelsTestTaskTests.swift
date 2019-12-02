//
//  HotelsTestTaskTests.swift
//  HotelsTestTaskTests
//
//  Created by Alexander Ershov on 30.11.2019.
//  Copyright © 2019 Alexander Ershov. All rights reserved.
//

import XCTest
@testable import HotelsTestTask

class HotelsTestTaskTests: XCTestCase {
    func testHotelBasicInfoDecodingForCorrectCase() {
        let basicHotelInfoJson = """
                                 {
                                     "id": 40611,
                                     "name": "Belleclaire Hotel",
                                     "address": "250 West 77th Street, Manhattan",
                                     "stars": 3.0,
                                     "distance": 100.0,
                                     "suites_availability": "1:44:21:87:99:34"
                                 }
                                 """

        let basicHotelInfo = BasicHotelInfo(
                id: 40611,
                name: "Belleclaire Hotel",
                address: "250 West 77th Street, Manhattan",
                stars: 3.0,
                distance: 100.0,
                suitesAvailability: [1, 44, 21, 87, 99, 34]
        )

        let basicHotelInfoDecoded = try! JSONDecoder().decode(BasicHotelInfo.self, from: basicHotelInfoJson.data(using: .utf8)!)

        XCTAssertEqual(basicHotelInfoDecoded.id, basicHotelInfo.id)
        XCTAssertEqual(basicHotelInfoDecoded.name, basicHotelInfo.name)
        XCTAssertEqual(basicHotelInfoDecoded.address, basicHotelInfo.address)
        XCTAssertEqual(basicHotelInfoDecoded.stars, basicHotelInfo.stars)
        XCTAssertEqual(basicHotelInfoDecoded.distance, basicHotelInfo.distance)
        XCTAssertEqual(basicHotelInfoDecoded.suitesAvailability, basicHotelInfo.suitesAvailability)
    }

    func testHotelBasicInfoDecodingForIncorrectCases() {
        let nullValue = """
                        {
                            "id": null,
                            "name": "Belleclaire Hotel",
                            "address": "250 West 77th Street, Manhattan",
                            "stars": 3.0,
                            "distance": 100.0,
                            "suites_availability": "1:44:21:87:99:34"
                        }
                        """
        let stringEmpty = """
                          {
                              "id": 1,
                              "name": "",
                              "address": "250 West 77th Street, Manhattan",
                              "stars": 3.0,
                              "distance": 100.0,
                              "suites_availability": "1:44:21:87:99:34"
                          }
                          """
        let incorrectSuitesAvailability = """
                                          {
                                              "id": 40611,
                                              "name": "Belleclaire Hotel",
                                              "address": "250 West 77th Street, Manhattan",
                                              "stars": 3.0,
                                              "distance": 100.0,
                                              "suites_availability": "1:aa"
                                          }
                                          """
        XCTAssertThrowsError(try JSONDecoder().decode(BasicHotelInfo.self, from: nullValue.data(using: .utf8)!))
        XCTAssertThrowsError(try JSONDecoder().decode(BasicHotelInfo.self, from: stringEmpty.data(using: .utf8)!))
        XCTAssertThrowsError(try JSONDecoder().decode(BasicHotelInfo.self, from: incorrectSuitesAvailability.data(using: .utf8)!))
    }

    func testHotelFullInfoDecoding() {
        let fullHotelInfoJson = """
                                {
                                    "id": 40611,
                                    "name": "Belleclaire Hotel",
                                    "address": "250 West 77th Street, Manhattan",
                                    "stars": 3.0,
                                    "distance": 100.0,
                                    "image": "1.jpg",
                                    "suites_availability": "1:44:21:87:99:34",
                                    "lat": 40.78260000000000,
                                    "lon": -73.98130000000000
                                }
                                """

        let fullHotelInfo = FullHotelInfo(
                id: 40611,
                name: "Belleclaire Hotel",
                address: "250 West 77th Street, Manhattan",
                stars: 3.0,
                distance: 100.0,
                image: 1,
                suitesAvailability: [1, 44, 21, 87, 99, 34],
                latitude: 40.78260000000000,
                longitude: -73.98130000000000
        )

        let fullHotelInfoDecoded = try! JSONDecoder().decode(FullHotelInfo.self, from: fullHotelInfoJson.data(using: .utf8)!)

        XCTAssertEqual(fullHotelInfoDecoded.id, fullHotelInfo.id)
        XCTAssertEqual(fullHotelInfoDecoded.name, fullHotelInfo.name)
        XCTAssertEqual(fullHotelInfoDecoded.address, fullHotelInfo.address)
        XCTAssertEqual(fullHotelInfoDecoded.stars, fullHotelInfo.stars)
        XCTAssertEqual(fullHotelInfoDecoded.distance, fullHotelInfo.distance)
        XCTAssertEqual(fullHotelInfoDecoded.image, fullHotelInfo.image)
        XCTAssertEqual(fullHotelInfoDecoded.suitesAvailability, fullHotelInfo.suitesAvailability)
        XCTAssertEqual(fullHotelInfoDecoded.latitude, fullHotelInfo.latitude)
        XCTAssertEqual(fullHotelInfoDecoded.longitude, fullHotelInfo.longitude)
    }

    func testHotelFullInfoDecodingForIncorrectCases() {
        let nullValue = """
                        {
                            "id": null,
                            "name": "Belleclaire Hotel",
                            "address": "250 West 77th Street, Manhattan",
                            "stars": 3.0,
                            "distance": 100.0,
                            "image": "1.jpg",
                            "suites_availability": "1:44:21:87:99:34",
                            "lat": 40.78260000000000,
                            "lon": -73.98130000000000
                        }
                        """
        let emptyString = """
                          {
                              "id": 123,
                              "name": "Belleclaire Hotel",
                              "address": "",
                              "stars": 3.0,
                              "distance": 100.0,
                              "image": "1.jpg",
                              "suites_availability": "1:44:21:87:99:34",
                              "lat": 40.78260000000000,
                              "lon": -73.98130000000000
                          }
                          """
        let incorrectSuitesAvailabilityString = """
                                                {
                                                    "id": 123,
                                                    "name": "Belleclaire Hotel",
                                                    "address": "250 West 77th Street, Manhattan",
                                                    "stars": 3.0,
                                                    "distance": 100.0,
                                                    "image": "1.jpg",
                                                    "suites_availability": "1:aaaa",
                                                    "lat": 40.78260000000000,
                                                    "lon": -73.98130000000000
                                                }
                                                """
        let idKeyDoesntExist = """
                               {
                                   "name": "Belleclaire Hotel",
                                   "address": "250 West 77th Street, Manhattan",
                                   "stars": 3.0,
                                   "distance": 100.0,
                                   "image": "1.jpg",
                                   "suites_availability": "1:44:21:87:99:34",
                                   "lat": 40.78260000000000,
                                   "lon": -73.98130000000000
                               }
                               """
        let imageIdIncorrect = """
                               {
                                   "id": 123,
                                   "name": "Belleclaire Hotel",
                                   "address": "250 West 77th Street, Manhattan",
                                   "stars": 3.0,
                                   "distance": 100.0,
                                   "image": "1a.jpg",
                                   "suites_availability": "1:aaaa",
                                   "lat": 40.78260000000000,
                                   "lon": -73.98130000000000
                               }
                               """

        XCTAssertThrowsError(try JSONDecoder().decode(FullHotelInfo.self, from: nullValue.data(using: .utf8)!))
        XCTAssertThrowsError(try JSONDecoder().decode(FullHotelInfo.self, from: emptyString.data(using: .utf8)!))
        XCTAssertThrowsError(try JSONDecoder().decode(FullHotelInfo.self, from: incorrectSuitesAvailabilityString.data(using: .utf8)!))
        XCTAssertThrowsError(try JSONDecoder().decode(FullHotelInfo.self, from: idKeyDoesntExist.data(using: .utf8)!))
        XCTAssertThrowsError(try JSONDecoder().decode(FullHotelInfo.self, from: imageIdIncorrect.data(using: .utf8)!))
    }
}
