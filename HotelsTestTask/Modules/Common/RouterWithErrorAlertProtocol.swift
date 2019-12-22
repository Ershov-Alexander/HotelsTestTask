//
//  RouterWithErrorAlertProtocol.swift
//  HotelsTestTask
//
//  Created by Alexander Ershov on 21.12.2019.
//  Copyright © 2019 Alexander Ershov. All rights reserved.
//

import Foundation
import UIKit


/// Contains method to present an alert with an error
protocol RouterWithErrorAlertProtocol {
    /// Presents error alert
    /// - Parameter error:an error that was occurred
    /// - Parameter retryHandler: retry logic to run after `error`
    func presentErrorAlert(with error: Error, retryHandler: @escaping () -> Void)
}
