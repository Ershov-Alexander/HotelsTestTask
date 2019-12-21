//
//  FullInfoView.swift
//  HotelsTestTask
//
//  Created by Alexander Ershov on 21.12.2019.
//  Copyright © 2019 Alexander Ershov. All rights reserved.
//

import Foundation
import UIKit
import MapKit

/// View for `FullInfo` module
protocol FullInfoViewProtocol: class {
    
    /// Configures view
    /// - Parameter viewModel: data to configure this view
    func configure(with viewModel: BasicInfoViewModelProtocol)
    
    /// Change hotel image
    /// - Parameter image: new image
    func setImage(_ image: UIImage)
    
    /// Change region for map view
    /// - Parameter region: new region
    func setRegionForMap(_ region: MKCoordinateRegion)
    
    /// Runs main activity indicator
    func runMainActivityIndicator()
    
    /// Stops main activity indicator
    func stopMainActivityIndicator()
    
    /// Runs image activity indicator
    func runImageActivityIndicator()
    
    /// Stops image activity indicator
    func stopImageActivityIndicator()
}
