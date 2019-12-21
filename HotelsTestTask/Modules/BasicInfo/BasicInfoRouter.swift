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
protocol BasicInfoRouterProtocol: class {
    
    /// Presents error alert
    /// - Parameter error:an error that was occurred
    func presentErrorAlert(with error: Error)
    
    /// Presents full info module
    /// - Parameter data: basic hotel info for full info module
    func presentFullInfoModule(with data: BasicHotelInfoProtocol)
}

class BasicInfoRouter: BasicInfoRouterProtocol {
    private let fullInfoViewControllerId = "FullInfoViewController"

    private weak var viewController: BasicInfoViewController!
    private lazy var storyboard = UIStoryboard(name: "Main", bundle: nil)
    
    init(viewController: BasicInfoViewController) {
        self.viewController = viewController
    }
    
    func presentFullInfoModule(with data: BasicHotelInfoProtocol) {
        let fullInfoViewController = storyboard.instantiateViewController(withIdentifier: fullInfoViewControllerId) as! FullInfoViewController
        fullInfoViewController.basicHotelInfo = data
        fullInfoViewController.navigationItem.title = data.name
        viewController.navigationController?.pushViewController(fullInfoViewController, animated: true)
    }
    
    func presentErrorAlert(with error: Error) {
        viewController.showErrorAlert(with: error)
    }
}
