//
//  BasicInfoInteractor.swift
//  HotelsTestTask
//
//  Created by Alexander Ershov on 19.12.2019.
//  Copyright © 2019 Alexander Ershov. All rights reserved.
//

import Foundation


/// Interactor for `BasicInfo` module
protocol BasicInfoInteractorProtocol: class {
    
    /// Basic hotel info data
    var basicHotelInfos: [BasicHotelInfoProtocol] { get }
    
    /// Notifies about data changing
    var delegate: BasicInfoInteractorDelegate? { get set }
    
    /// Starts downloading basic hotel info
    func downloadBasicHotelInfo()
    
    /// Cancels downloading basic hotel info
    func cancelNetworkRequest()
    
    /// Sorts basic hotel info by distance
    func sortHotelsByDistance()
    
    /// Sorts basic hotel info by number of available suits
    func sortHotelsByNumberOfAvailableSuits()
}

/// Notifies about data changing in `BasicInfoInteractorProtocol`
protocol BasicInfoInteractorDelegate: class {
    
    /// Invokes when `basicHotelInfos` is updated
    /// - Parameter newData: new value for `basicHotelInfos`
    func hotelInfoUpdated(newData: [BasicHotelInfoProtocol])
    
    /// Invokes when error occured while downloading `basicHotelInfos`
    /// - Parameter error: error that accoured
    func errorOccurredWhileDownloading(error: Error)
}

class BasicInfoInteractor: BasicInfoInteractorProtocol {
    
    private let networkService: NetworkServiceProtocol
    
    var basicHotelInfos: [BasicHotelInfoProtocol] = []
    weak var delegate: BasicInfoInteractorDelegate?
    
    required init(delegate: BasicInfoInteractorDelegate, networkService: NetworkServiceProtocol = NetworkService()) {
        self.networkService = networkService
        self.delegate = delegate
    }
    
    func downloadBasicHotelInfo() {
        networkService.makeRequestForBasicInfo { [weak self] in
            guard let self = self else {
                return
            }
            switch $0 {
            case .success(let hotelInfos):
                self.basicHotelInfos = hotelInfos
                self.delegate?.hotelInfoUpdated(newData: hotelInfos)
            case .failure(let error):
                self.delegate?.errorOccurredWhileDownloading(error: error)
            }
        }
    }
    
    func cancelNetworkRequest() {
        networkService.cancelRequest()
    }
    
    func sortHotelsByDistance() {
        basicHotelInfos = basicHotelInfos.sorted(by: { $0.distance < $1.distance })
        delegate?.hotelInfoUpdated(newData: basicHotelInfos)
    }
    
    func sortHotelsByNumberOfAvailableSuits() {
        basicHotelInfos = basicHotelInfos.sorted(by: { $0.suitesAvailability.count > $1.suitesAvailability.count })
        delegate?.hotelInfoUpdated(newData: basicHotelInfos)
    }
}
