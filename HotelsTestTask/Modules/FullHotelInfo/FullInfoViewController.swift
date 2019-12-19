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
    var basicHotelInfo: BasicHotelInfoProtocol?

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
        if let hotelInfo = basicHotelInfo {
            fillUI(with: hotelInfo)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        makeRequestForFullInfo()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        networkHandler.cancelRequest()
    }

    // MARK: - Network requests
    private func makeRequestForFullInfo() {
        mainActivityIndicator.startAnimating()
        guard let id = basicHotelInfo?.id else {
            return
        }
        networkHandler.makeRequestForFullInfo(with: id) { [weak self] result in
            guard let self = self else {
                return
            }
            DispatchQueue.main.async {
                self.mainActivityIndicator.stopAnimating()
                switch result {
                case .success(let hotelInfo):
                    self.fillUI(with: hotelInfo)
                    let imageId = hotelInfo.image
                    self.makeRequestForImage(with: imageId)
                case .failure(let error):
                    self.showErrorAlert(with: error)
                }
            }
        }
    }

    private func makeRequestForImage(with id: Int) {
        imageActivityIndicator.startAnimating()
        networkHandler.makeRequestForImage(with: id) { [weak self] result in
            guard let self = self else {
                return
            }
            DispatchQueue.main.async {
                self.imageActivityIndicator.stopAnimating()
                switch result {
                case .success(let uiImage):
                    self.updateImageView(with: uiImage)
                case .failure(let error):
                    self.showErrorAlert(with: error)
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

    private func fillUI(with hotelInfo: BasicHotelInfoProtocol) {
        starsLabel.text = String(repeating: "⭐️", count: Int(hotelInfo.stars))
        starsLabel.isHidden = false

        numberOfSuitsAvailableLabel.text = "🛏 \(hotelInfo.suitesAvailability.count) suits available"
        numberOfSuitsAvailableLabel.isHidden = false

        addressLabel.text = hotelInfo.address
        addressLabel.isHidden = false

        distanceToTheCentreLabel.text = "🏃‍️ Distance to the centre: \(hotelInfo.distance)"
        distanceToTheCentreLabel.isHidden = false
    }
    
    private func fillUI(with hotelInfo: FullHotelInfoProtocol) {
        let location = CLLocation(latitude: hotelInfo.latitude, longitude: hotelInfo.longitude)
        let region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: mapScale, longitudinalMeters: mapScale)
        mapView.setRegion(region, animated: true)
        mapView.isHidden = false
    }
    
    private func updateImageView(with image: UIImage) {
        let onePixel = 1.0 / image.scale
        
        let rectToCrop = CGRect(
                origin: CGPoint(x: onePixel, y: onePixel),
                size: CGSize(width: image.size.width - 2 * onePixel, height: image.size.height - 2 * onePixel)
        )
        guard let croppedCGImage = image.cgImage?.cropping(to: rectToCrop) else {
            return
        }
        let uiImage = UIImage(cgImage: croppedCGImage)
        hotelImageView.image = uiImage
        hotelImageView.isHidden = false
    }

    private func showErrorAlert(with error: Error) {
        let alertController = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default)
        alertController.addAction(action)
        present(alertController, animated: true, completion: nil)
    }
}
