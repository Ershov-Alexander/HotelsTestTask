//
//  BasicInfoView.swift
//  HotelsTestTask
//
//  Created by Alexander Ershov on 19.12.2019.
//  Copyright © 2019 Alexander Ershov. All rights reserved.
//

import Foundation


/// View for `BasicInfo` module
protocol BasicInfoViewProtocol: class {

    /// Runs activity indicator
    func runActivityIndicator()

    /// Stops activity indicator
    func stopActivityIndicator()

    /// Updates table view
    func updateTableView()
}
