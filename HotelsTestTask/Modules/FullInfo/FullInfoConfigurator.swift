//
//  FullInfoConfigurator.swift
//  HotelsTestTask
//
//  Created by Alexander Ershov on 21.12.2019.
//  Copyright © 2019 Alexander Ershov. All rights reserved.
//

import Foundation

/// Configures VIPER parts for `FullInfo` module
protocol FullInfoConfiguratorProtocol: class {
    func configure(with viewController: FullInfoViewController, hotelInfo: BasicHotelInfoProtocol)
}

class FullInfoConfigurator: FullInfoConfiguratorProtocol {
    func configure(with viewController: FullInfoViewController, hotelInfo: BasicHotelInfoProtocol) {
        let presenter = FullInfoPresenter(view: viewController)
        let interactor = FullInfoInteractor(basicHotelInfo: hotelInfo)
        interactor.delegate = presenter
        let router = FullInfoRouter(viewController: viewController)

        viewController.presenter = presenter
        presenter.interactor = interactor
        presenter.router = router
    }
}
