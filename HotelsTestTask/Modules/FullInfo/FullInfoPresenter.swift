//
//  FullInfoPresenter.swift
//  HotelsTestTask
//
//  Created by Alexander Ershov on 21.12.2019.
//  Copyright © 2019 Alexander Ershov. All rights reserved.
//

import Foundation
import MapKit

/// Presenter for `FullInfo` module
protocol FullInfoPresenterProtocol: class {

    /// Configures view using basic info provided by `BasicInfo` module
    func configureViewWithBasicInfo()

    /// Runs when view did appear
    func viewDidAppear()

    /// Runs when view did disappear
    func viewDidDisappear()
}

class FullInfoPresenter: FullInfoPresenterProtocol, FullInfoInteractorDelegate {
    // MARK: - Constants
    private let mapScale: CLLocationDistance = 1000

    // MARK: - Viper parts
    var router: FullInfoRouterProtocol!
    var interactor: FullInfoInteractorProtocol!
    weak var view: FullInfoViewProtocol!

    init(view: FullInfoViewProtocol) {
        self.view = view
    }

    // MARK: - FullInfoPresenterProtocol
    func configureViewWithBasicInfo() {
        let viewModel = BasicInfoViewModel(hotelInfo: interactor.basicHotelInfo)
        view.configure(with: viewModel)
    }

    func viewDidAppear() {
        guard let _ = interactor.fullHotelInfo else {
            view.runMainActivityIndicator()
            interactor.downloadFullInfo()
            return
        }
    }

    func viewDidDisappear() {
        interactor.cancelNetworkRequest()
    }

    // MARK: - FullInfoInteractorDelegate
    func fullInfoDownloaded() {
        view.stopMainActivityIndicator()
        guard let fullInfo = interactor.fullHotelInfo else {
            return
        }
        let mapRegion = getMapRegion(for: fullInfo)
        view.setRegionForMap(mapRegion)
        view.runImageActivityIndicator()
        interactor.downloadImage()
    }

    func imageDownloaded() {
        view.stopImageActivityIndicator()
        if let image = interactor.image {
            view.setImage(image)
        }
    }

    func errorOccurred(error: Error) {
        view.stopMainActivityIndicator()
        view.stopImageActivityIndicator()
        router.presentErrorAlert(with: error) { [weak self] in
            self?.view.runMainActivityIndicator()
            self?.interactor.downloadFullInfo()
        }
    }

    private func getMapRegion(for hotelInfo: FullHotelInfoProtocol) -> MKCoordinateRegion {
        let location = CLLocation(latitude: hotelInfo.latitude, longitude: hotelInfo.longitude)
        return MKCoordinateRegion(center: location.coordinate, latitudinalMeters: mapScale, longitudinalMeters: mapScale)
    }
}
