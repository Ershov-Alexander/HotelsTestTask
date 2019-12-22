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
    func configure(with viewModel: BasicInfoViewModelProtocol)
}

class BasicInfoTableViewCell: UITableViewCell, BasicInfoCellViewProtocol {
    @IBOutlet private weak var numberOfStarsLabel: UILabel!
    @IBOutlet private weak var hotelNameLabel: UILabel!
    @IBOutlet private weak var numberOfSuitsAvailableLabel: UILabel!
    @IBOutlet private weak var hotelAddressLabel: UILabel!
    @IBOutlet private weak var distanceToTheCentreLabel: UILabel!

    func configure(with viewModel: BasicInfoViewModelProtocol) {
        numberOfStarsLabel.text = viewModel.numberOfStars
        hotelNameLabel.text = viewModel.hotelName
        numberOfSuitsAvailableLabel.text = viewModel.numberOfSuitsAvailable
        hotelAddressLabel.text = viewModel.hotelAddress
        distanceToTheCentreLabel.text = viewModel.distanceToTheCentre
    }
}
