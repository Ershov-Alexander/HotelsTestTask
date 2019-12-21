//
//  FullHotelInfoViewController.swift
//  HotelsTestTask
//
//  Created by Alexander Ershov on 01.12.2019.
//  Copyright © 2019 Alexander Ershov. All rights reserved.
//

import UIKit
import MapKit

/// Shows full info with an image for specific hotel
class FullInfoViewController: UIViewController {
    // MARK: - VIPER parts
    var presenter: FullInfoPresenterProtocol!
    let configurator: FullInfoConfiguratorProtocol = FullInfoConfigurator()

    // MARK: - IBOutlets
    @IBOutlet private weak var starsLabel: UILabel!
    @IBOutlet private weak var hotelImageView: UIImageView!
    @IBOutlet private weak var numberOfSuitsAvailableLabel: UILabel!
    @IBOutlet private weak var addressLabel: UILabel!
    @IBOutlet private weak var mapView: MKMapView!
    @IBOutlet private weak var distanceToTheCentreLabel: UILabel!
    @IBOutlet private weak var imageActivityIndicator: UIActivityIndicatorView!
    @IBOutlet private weak var mainActivityIndicator: UIActivityIndicatorView!

    // MARK: - View controller life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.isHidden = true
        presenter.configureViewWithBasicInfo()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        presenter.viewDidAppear()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        presenter.viewDidDisappear()
    }
}

// MARK: - FullInfoViewProtocol
extension FullInfoViewController: FullInfoViewProtocol {
    func configure(with viewModel: BasicInfoViewModelProtocol) {
        DispatchQueue.main.async {
            self.starsLabel.text = viewModel.numberOfStars
            self.numberOfSuitsAvailableLabel.text = viewModel.numberOfSuitsAvailable
            self.addressLabel.text = viewModel.hotelAddress
            self.distanceToTheCentreLabel.text = viewModel.distanceToTheCentre
        }
    }
    
    func setImage(_ image: UIImage) {
        DispatchQueue.main.async {
            self.hotelImageView.image = image
            self.hotelImageView.isHidden = false
        }
    }
    
    func setRegionForMap(_ region: MKCoordinateRegion) {
        DispatchQueue.main.async {
            self.mapView.setRegion(region, animated: true)
            self.mapView.isHidden = false
        }
    }
    
    func runMainActivityIndicator() {
        DispatchQueue.main.async {
            self.mainActivityIndicator.startAnimating()
        }
    }
    
    func stopMainActivityIndicator() {
        DispatchQueue.main.async {
            self.mainActivityIndicator.stopAnimating()
        }
    }
    
    func runImageActivityIndicator() {
        DispatchQueue.main.async {
            self.imageActivityIndicator.startAnimating()
        }
    }
    
    func stopImageActivityIndicator() {
        DispatchQueue.main.async {
            self.imageActivityIndicator.stopAnimating()
        }
    }
}
