//
//  BasicHotelInfoTableViewCell.swift
//  HotelsTestTask
//
//  Created by Alexander Ershov on 30.11.2019.
//  Copyright © 2019 Alexander Ershov. All rights reserved.
//

import UIKit

class BasicHotelInfoTableViewCell: UITableViewCell {
    @IBOutlet private weak var numberOfStarsLabel: UILabel!
    @IBOutlet private weak var hotelNameLabel: UILabel!
    @IBOutlet private weak var numberOfSuitsAvailableLabel: UILabel!
    @IBOutlet private weak var hotelAddressLabel: UILabel!
    @IBOutlet private weak var distanceToTheCentreLabel: UILabel!

    func fillUI(with hotelInfo: BasicHotelInfoProtocol) {
        numberOfStarsLabel.text = String.init(repeating: "⭐️", count: Int(hotelInfo.stars))
        hotelNameLabel.text = hotelInfo.name
        numberOfSuitsAvailableLabel.text = "🛏 \(hotelInfo.suitesAvailability.count) suits available"
        hotelAddressLabel.text = hotelInfo.address
        distanceToTheCentreLabel.text = "🏃‍️ Distance to the centre: \(hotelInfo.distance)"
    }
}

