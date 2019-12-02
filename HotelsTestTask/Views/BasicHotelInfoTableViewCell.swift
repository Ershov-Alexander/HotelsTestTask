//
//  BasicHotelInfoTableViewCell.swift
//  HotelsTestTask
//
//  Created by Alexander Ershov on 30.11.2019.
//  Copyright © 2019 Alexander Ershov. All rights reserved.
//

import UIKit

class BasicHotelInfoTableViewCell: UITableViewCell {
    @IBOutlet weak var numberOfStars: UILabel!
    @IBOutlet weak var hotelName: UILabel!
    @IBOutlet weak var numberOfSuitsAvailable: UILabel!
    @IBOutlet weak var hotelAddress: UILabel!
    @IBOutlet weak var distanceToTheCentre: UILabel!

    func fillUI(with hotelInfo: BasicHotelInfo) {
        numberOfStars.text = String.init(repeating: "⭐️", count: Int(hotelInfo.stars))
        hotelName.text = hotelInfo.name
        numberOfSuitsAvailable.text = "🛏 \(hotelInfo.suitesAvailability.count) suits available"
        hotelAddress.text = hotelInfo.address
        distanceToTheCentre.text = "🏃‍️ Distance to the centre: \(hotelInfo.distance)"
    }
}

