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
        let errorString = NSLocalizedString("Error", comment: "")
        let okString = NSLocalizedString("Ok", comment: "")
        
        let alertController = UIAlertController(title: errorString,
                                                message: error.localizedDescription,
                                                preferredStyle: .alert)
        let action = UIAlertAction(title: okString, style: .default)
        alertController.addAction(action)
        
        present(alertController, animated: true, completion: nil)
    }
}
