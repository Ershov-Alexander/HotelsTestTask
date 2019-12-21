//
//  BasicHotelInfoTableViewCell.swift
//  HotelsTestTask
//
//  Created by Alexander Ershov on 30.11.2019.
//  Copyright © 2019 Alexander Ershov. All rights reserved.
//

import UIKit


/// View protocol for `BasicInfo` table view cell
protocol BasicInfoCellViewProtocol: class {
    
    /// Configures table view cell
    /// - Parameter viewModel: data for configuration
    func configure(with viewModel: BasicInfoCellViewModelProtocol)
}

/// View model protocol for `BasicInfo` table view cell
protocol BasicInfoCellViewModelProtocol {
    
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

class BasicInfoTableViewCell: UITableViewCell, BasicInfoCellViewProtocol {
    @IBOutlet private weak var numberOfStarsLabel: UILabel!
    @IBOutlet private weak var hotelNameLabel: UILabel!
    @IBOutlet private weak var numberOfSuitsAvailableLabel: UILabel!
    @IBOutlet private weak var hotelAddressLabel: UILabel!
    @IBOutlet private weak var distanceToTheCentreLabel: UILabel!

    func configure(with viewModel: BasicInfoCellViewModelProtocol) {
        numberOfStarsLabel.text = viewModel.numberOfStars
        hotelNameLabel.text = viewModel.hotelName
        numberOfSuitsAvailableLabel.text = viewModel.numberOfSuitsAvailable
        hotelAddressLabel.text = viewModel.hotelAddress
        distanceToTheCentreLabel.text = viewModel.distanceToTheCentre
    }
}

struct BasicInfoCellViewModel: BasicInfoCellViewModelProtocol {
    let numberOfStars: String
    let hotelName: String
    let numberOfSuitsAvailable: String
    let hotelAddress: String
    let distanceToTheCentre: String
    
    init(hotelInfo: BasicHotelInfoProtocol) {
        numberOfStars = String(repeating: "⭐️", count: Int(hotelInfo.stars))
        hotelName = hotelInfo.name
        numberOfSuitsAvailable = "🛏 \(hotelInfo.suitesAvailability.count) suits available"
        hotelAddress = hotelInfo.address
        distanceToTheCentre = "🏃‍️ Distance to the centre: \(hotelInfo.distance)"
    }
}

