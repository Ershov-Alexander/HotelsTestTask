//
//  ViewController+ErrorAlert.swift
//  HotelsTestTask
//
//  Created by Alexander Ershov on 20.12.2019.
//  Copyright © 2019 Alexander Ershov. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    func presentErrorAlert(with error: Error) {
        let alertController = UIAlertController(title: "Error",
                                                message: error.localizedDescription,
                                                preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(action)
        present(alertController, animated: true, completion: nil)
    }
}
