//
//  Hotels.swift
//  HotelsTestTask
//
//  Created by Alexander Ershov on 30.11.2019.
//  Copyright © 2019 Alexander Ershov. All rights reserved.
//

import Foundation

/// Represents full hotel information
protocol FullHotelInfoProtocol {
    /// Basic hotel information
    var basicHotelInfo: BasicHotelInfoProtocol { get }
    
    /// Image id
    var image: Int { get }

    /// Latitude of hotel location
    var latitude: Double { get }

    /// Longitude of hotel location
    var longitude: Double { get }
}

