//
//  BasicInfoConfigurator.swift
//  HotelsTestTask
//
//  Created by Alexander Ershov on 19.12.2019.
//  Copyright © 2019 Alexander Ershov. All rights reserved.
//

import Foundation


/// Configures VIPER parts for `BasicInfo` module
protocol BasicInfoConfiguratorProtocol: class {
    func configure(with viewController: BasicInfoViewController)
}

class BasicInfoConfigurator: BasicInfoConfiguratorProtocol {
    func configure(with viewController: BasicInfoViewController) {
        let presenter = BasicInfoPresenter(view: viewController)
        let interactor = BasicInfoInteractor(delegate: presenter)
        let router = BasicInfoRouter(viewController: viewController)

        viewController.presenter = presenter
        presenter.interactor = interactor
        presenter.router = router
    }
}

