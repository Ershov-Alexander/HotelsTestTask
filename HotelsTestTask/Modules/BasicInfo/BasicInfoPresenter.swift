//
//  BasicInfoPresenter.swift
//  HotelsTestTask
//
//  Created by Alexander Ershov on 19.12.2019.
//  Copyright © 2019 Alexander Ershov. All rights reserved.
//

import Foundation


/// Presenter for BasicInfo module
protocol BasicInfoPresenterProtocol: class {
    
    /// Router
    var router: BasicInfoRouterProtocol! { get set }
    
    /// Returns number of hotels for table view
    var numberOfHotels: Int { get }
    
    /// Invokes when view disappeared
    func viewDidAppear()
    
    /// Invokes when view appeared
    func viewDidDissapear()
        
    /// Configure table view cell with hotel info data
    /// - Parameters:
    ///   - cell: table view cell
    ///   - index: cell's index
    func configure(cell: BasicInfoCellViewProtocol, at index: IndexPath)
        
    /// Invokes when table view cell tapped
    /// - Parameter index: cell's index
    func tableViewCellTapped(at index: IndexPath)
    
    /// Invokes when sort by distance button tapped
    func sortByDistanceTapped()
    
    /// Invokes when sort by number of suits button tapped
    func sortByNumberOfSuitsTapped()
}

class BasicInfoPresenter: BasicInfoPresenterProtocol, BasicInfoInteractorDelegate {
    weak var view: BasicInfoViewProtocol!
    var interactor: BasicInfoInteractorProtocol!
    
    required init(view: BasicInfoViewProtocol) {
        self.view = view
    }

    // MARK: - BasicInfoPresenterProtocol
    var router: BasicInfoRouterProtocol!
    
    var numberOfHotels: Int {
        return interactor.basicHotelInfos.count
    }
    
    func viewDidAppear() {
        if interactor.basicHotelInfos.isEmpty {
            view.runActivityIndicator()
            interactor.downloadBasicHotelInfo()
        }
    }
    
    func viewDidDissapear() {
        interactor.cancelNetworkRequest()
    }
    
    func configure(cell: BasicInfoCellViewProtocol, at index: IndexPath) {
        let viewModel = BasicInfoCellViewModel(hotelInfo: interactor.basicHotelInfos[index.row])
        cell.configure(with: viewModel)
    }
    
    func tableViewCellTapped(at index: IndexPath) {
        router.presentFullInfoModule(with: interactor.basicHotelInfos[index.row])
    }
    
    func sortByDistanceTapped() {
        interactor.sortHotelsByDistance()
    }
    
    func sortByNumberOfSuitsTapped() {
        interactor.sortHotelsByNumberOfAvailableSuits()
    }
    
    // MARK: - BasicInfoInteractorDelegate
    func hotelInfoUpdated(newData: [BasicHotelInfoProtocol]) {
        view.updateTableView()
        view.stopActivityIndicator()
    }
    
    func errorOccurredWhileDownloading(error: Error) {
        router.presentErrorAlert(with: error)
    }
}
