//
//  FullHotelInfoViewController.swift
//  HotelsTestTask
//
//  Created by Alexander Ershov on 01.12.2019.
//  Copyright © 2019 Alexander Ershov. All rights reserved.
//

import UIKit
import MapKit

/// Shows full info with an image for specific hotel.
class FullInfoViewController: UIViewController {
    // MARK: - Variables and constants
    private let mapScale: CLLocationDistance = 1000
    private let networkHandler = NetworkHandler()
    var basicHotelInfo: BasicHotelInfo?

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
        hideViews()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        makeRequestForFullInfo()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        networkHandler.cancelRequest()
    }

    // MARK: - Network requests
    private func makeRequestForFullInfo() {
        mainActivityIndicator.startAnimating()
        if let id = basicHotelInfo?.id {
            networkHandler.makeRequestForFullInfo(with: id) { [weak self] error, data in
                guard let self = self else {
                    return
                }
                DispatchQueue.main.async {
                    self.mainActivityIndicator.stopAnimating()
                    if let error = error {
                        self.showErrorAlert(with: error)
                    } else if let data = data {
                        self.fillUI(with: data)
                        let imageId = data.image
                        self.makeRequestForImage(with: imageId)
                    }
                }
            }
        }
    }

    private func makeRequestForImage(with id: Int) {
        imageActivityIndicator.startAnimating()
        networkHandler.makeRequestForImage(with: id) { [weak self] error, data in
            guard let self = self else {
                return
            }
            DispatchQueue.main.async {
                self.imageActivityIndicator.stopAnimating()
                if let error = error {
                    self.showErrorAlert(with: error)
                } else if let data = data {
                    self.updateImageView(with: data)
                }
            }
        }
    }

    // MARK: - UI functions
    private func hideViews() {
        starsLabel.isHidden = true
        numberOfSuitsAvailableLabel.isHidden = true
        addressLabel.isHidden = true
        mapView.isHidden = true
        distanceToTheCentreLabel.isHidden = true
    }

    private func fillUI(with hotelInfo: FullHotelInfo) {
        starsLabel.text = String(repeating: "⭐️", count: Int(hotelInfo.stars))
        starsLabel.isHidden = false

        numberOfSuitsAvailableLabel.text = "🛏 \(hotelInfo.suitesAvailability.count) suits available"
        numberOfSuitsAvailableLabel.isHidden = false

        addressLabel.text = hotelInfo.address
        addressLabel.isHidden = false

        distanceToTheCentreLabel.text = "🏃‍️ Distance to the centre: \(hotelInfo.distance)"
        distanceToTheCentreLabel.isHidden = false

        let location = CLLocation(latitude: hotelInfo.latitude, longitude: hotelInfo.longitude)
        let region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: mapScale, longitudinalMeters: mapScale)
        mapView.setRegion(region, animated: true)
        mapView.isHidden = false
    }
    
    private func updateImageView(with image: UIImage) {
        let rectToCrop = CGRect(
                origin: CGPoint(x: 1, y: 1),
                size: CGSize(width: image.size.width - 2, height: image.size.height - 2)
        )
        if let croppedCGImage = image.cgImage?.cropping(to: rectToCrop) {
            let uiImage = UIImage(cgImage: croppedCGImage)
            hotelImageView.image = uiImage
            hotelImageView.isHidden = false
        }
    }

    private func showErrorAlert(with message: String) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default)
        alertController.addAction(action)
        present(alertController, animated: true, completion: nil)
    }
}
