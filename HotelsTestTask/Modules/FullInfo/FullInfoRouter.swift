//
//  FullInfoRouter.swift
//  HotelsTestTask
//
//  Created by Alexander Ershov on 21.12.2019.
//  Copyright © 2019 Alexander Ershov. All rights reserved.
//

import Foundation

/// Router for `FullInfo` module
protocol FullInfoRouterProtocol: class, RouterWithErrorAlertProtocol {
}

class FullInfoRouter: FullInfoRouterProtocol {
    private weak var viewController: FullInfoViewController!

    init(viewController: FullInfoViewController) {
        self.viewController = viewController
    }

    func presentErrorAlert(with error: Error, retryHandler: @escaping () -> Void) {
        viewController.presentErrorAlert(with: error, retryHandler: retryHandler)
    }
}

