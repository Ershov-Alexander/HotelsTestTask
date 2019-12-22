//
//  HotelBasicInfo.swift
//  HotelsTestTask
//
//  Created by Alexander Ershov on 30.11.2019.
//  Copyright © 2019 Alexander Ershov. All rights reserved.
//

import Foundation

/// Represents basic hotel information
protocol BasicHotelInfoProtocol {
    /// Hotel id
    var id: Int { get }

    /// Hotel name
    var name: String { get }

    /// Hotel address
    var address: String { get }

    /// Number of stars
    var stars: Double { get }

    /// Distance to the centre of a city
    var distance: Double { get }

    /// Numbers of available suites
    var suitesAvailability: [Int] { get }
}
