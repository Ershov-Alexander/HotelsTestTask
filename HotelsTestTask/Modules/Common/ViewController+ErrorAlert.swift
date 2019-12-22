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
    func presentErrorAlert(with error: Error, retryHandler: @escaping () -> Void) {
        let errorString = NSLocalizedString("Error", comment: "")
        let okString = NSLocalizedString("Ok", comment: "")
        let retryString = NSLocalizedString("Try again", comment: "")

        let alertController = UIAlertController(title: errorString,
                message: error.localizedDescription,
                preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: okString, style: .cancel)
        let retryAction = UIAlertAction(title: retryString, style: .default) { _ in
            retryHandler()
        }
        alertController.addAction(okAction)
        alertController.addAction(retryAction)

        present(alertController, animated: true, completion: nil)
    }
}
