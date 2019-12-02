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
    private let networkHandler = NetworkHandler()
    var basicHotelInfo: BasicHotelInfo?

    // MARK: - IBOutlets
    @IBOutlet weak var stars: UILabel!
    @IBOutlet weak var hotelImage: UIImageView!
    @IBOutlet weak var numberOfSuitsAvailable: UILabel!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var distanceToTheCentre: UILabel!
    @IBOutlet weak var imageActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var mainActivityIndicator: UIActivityIndicatorView!

    // MARK: - View controller life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        hideViews()
    }

    override func viewWillAppear(_ animated: Bool) {
        makeRequestForFullInfo()
    }

    override func viewWillDisappear(_ animated: Bool) {
        networkHandler.cancelRequest()
    }

    // MARK: - Network requests
    func makeRequestForFullInfo() {
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

    func makeRequestForImage(with id: Int) {
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
                    let rectToCrop = CGRect(
                            origin: CGPoint(x: 1, y: 1),
                            size: CGSize(width: data.size.width - 2, height: data.size.height - 2)
                    )
                    let croppedImage = data.cgImage?.cropping(to: rectToCrop).map { UIImage(cgImage: $0) }
                    self.hotelImage.image = croppedImage
                    self.hotelImage.isHidden = false
                }
            }
        }
    }

    // MARK: - UI functions
    func hideViews() {
        stars.isHidden = true
        numberOfSuitsAvailable.isHidden = true
        address.isHidden = true
        mapView.isHidden = true
        distanceToTheCentre.isHidden = true
    }

    func fillUI(with hotelInfo: FullHotelInfo) {
        stars.text = String(repeating: "⭐️", count: Int(hotelInfo.stars))
        stars.isHidden = false
        numberOfSuitsAvailable.text = "🛏 \(hotelInfo.suitesAvailability.count) suits available"
        numberOfSuitsAvailable.isHidden = false
        address.text = hotelInfo.address
        address.isHidden = false
        distanceToTheCentre.text = "🏃‍️ Distance to the centre: \(hotelInfo.distance)"
        distanceToTheCentre.isHidden = false
        let location = CLLocation(latitude: hotelInfo.latitude, longitude: hotelInfo.longitude)
        mapView.setRegion(MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000), animated: true)
        mapView.isHidden = false
    }

    func showErrorAlert(with message: String) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default)
        alertController.addAction(action)
        present(alertController, animated: true, completion: nil)
    }
}
