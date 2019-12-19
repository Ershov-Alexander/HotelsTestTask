//
//  BasicInfoViewController.swift
//  HotelsTestTask
//
//  Created by Alexander Ershov on 30.11.2019.
//  Copyright © 2019 Alexander Ershov. All rights reserved.
//

import UIKit

/// Shows table with basic info for all hotels.
class BasicInfoViewController: UIViewController {
    // MARK: - Variables and constants
    private let networkHandler = NetworkHandler()
    private var tableData: [BasicHotelInfo] = []

    // MARK: - IBOutlets
    @IBOutlet weak private var tableView: UITableView!
    @IBOutlet weak private var activityIndicator: UIActivityIndicatorView!

    // MARK: - IBActions
    @IBAction private func sortByDistanceToTheCentre(_ sender: UIBarButtonItem) {
        tableData = tableData.sorted(by: { $0.distance < $1.distance })
        tableView.reloadData()
    }

    @IBAction private func sortByNumberOfAvailableSuits(_ sender: UIBarButtonItem) {
        tableData = tableData.sorted(by: { $0.suitesAvailability.count > $1.suitesAvailability.count })
        tableView.reloadData()
    }

    // MARK: - View controller life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        self.tableView.isHidden = true
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let index = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: index, animated: true)
        }
        if tableData.isEmpty {
            makeRequestForBasicInfo()
        }
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        networkHandler.cancelRequest()
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let cell = sender as? BasicHotelInfoTableViewCell,
           let index = tableView.indexPath(for: cell),
           let vc = segue.destination as? FullInfoViewController {
            vc.basicHotelInfo = tableData[index.row]
            vc.navigationItem.title = vc.basicHotelInfo?.name
        }
    }

    // MARK: - Utility functions
    private func makeRequestForBasicInfo() {
        activityIndicator.startAnimating()
        networkHandler.makeRequestForBasicInfo { [weak self] result in
            guard let self = self else {
                return
            }
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
                switch result {
                case .success(let hotelInfos):
                    self.tableData = hotelInfos
                    self.tableView.reloadData()
                    self.tableView.isHidden = false
                case .failure(let error):
                    self.showErrorAlert(with: error)
                    
                }
            }
        }
    }

    private func showErrorAlert(with error: Error) {
        let alertController = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default)
        alertController.addAction(action)
        present(alertController, animated: true, completion: nil)
    }

}

// MARK: - UITableViewDataSource
extension BasicInfoViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableData.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BasicHotelInfoCell", for: indexPath)
        guard let basicInfoCell = cell as? BasicHotelInfoTableViewCell else {
            return cell
        }
        basicInfoCell.fillUI(with: tableData[indexPath.row])
        return basicInfoCell
    }
}
