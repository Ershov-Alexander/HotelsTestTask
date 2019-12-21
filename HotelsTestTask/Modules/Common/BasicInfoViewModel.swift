//
//  BasicInfoViewModel.swift
//  HotelsTestTask
//
//  Created by Alexander Ershov on 21.12.2019.
//  Copyright © 2019 Alexander Ershov. All rights reserved.
//

import Foundation

/// View model protocol for `BasicInfo` table view cell
protocol BasicInfoViewModelProtocol {
    
    /// Text for number of start label
    var numberOfStars: String { get }
    
    /// Text for hotel name label
    var hotelName: String { get }
    
    /// Text for number of available suits label
    var numberOfSuitsAvailable: String { get }
    
    /// Text for hotel address label
    var hotelAddress: String { get }
    
    /// Text for distance to the centre label
    var distanceToTheCentre: String { get }
}

struct BasicInfoViewModel: BasicInfoViewModelProtocol {
    private let suitsAvailableString = NSLocalizedString("suits available", comment: "")
    private let distanceToTheCentreString = NSLocalizedString("Distance to the centre", comment: "")

    let numberOfStars: String
    let hotelName: String
    let numberOfSuitsAvailable: String
    let hotelAddress: String
    let distanceToTheCentre: String
    
    init(hotelInfo: BasicHotelInfoProtocol) {
        numberOfStars = String(repeating: "⭐️", count: Int(hotelInfo.stars))
        hotelName = hotelInfo.name
        numberOfSuitsAvailable = "🛏 \(hotelInfo.suitesAvailability.count) \(suitsAvailableString)"
        hotelAddress = hotelInfo.address
        distanceToTheCentre = "🏃‍️ \(distanceToTheCentreString): \(hotelInfo.distance)"
    }
}

