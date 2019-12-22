//
//  BasicInfoRouter.swift
//  HotelsTestTask
//
//  Created by Alexander Ershov on 19.12.2019.
//  Copyright © 2019 Alexander Ershov. All rights reserved.
//

import Foundation
import UIKit


/// Router for `BasicInfo` module
protocol BasicInfoRouterProtocol: class, RouterWithErrorAlertProtocol {

    /// Presents full info module
    /// - Parameter data: basic hotel info for full info module
    func presentFullInfoModule(with hotelInfo: BasicHotelInfoProtocol)
}

class BasicInfoRouter: BasicInfoRouterProtocol {
    private let fullInfoViewControllerId = "FullInfoViewController"
    private let storyboardId = "Main"

    private weak var viewController: BasicInfoViewController!
    private lazy var storyboard = UIStoryboard(name: storyboardId, bundle: nil)

    init(viewController: BasicInfoViewController) {
        self.viewController = viewController
    }

    func presentFullInfoModule(with hotelInfo: BasicHotelInfoProtocol) {
        let fullInfoViewController = storyboard.instantiateViewController(withIdentifier: fullInfoViewControllerId) as! FullInfoViewController
        fullInfoViewController.navigationItem.title = hotelInfo.name
        fullInfoViewController.configurator.configure(with: fullInfoViewController, hotelInfo: hotelInfo)
        viewController.navigationController?.pushViewController(fullInfoViewController, animated: true)
    }

    func presentErrorAlert(with error: Error) {
        viewController.presentErrorAlert(with: error)
    }
}
