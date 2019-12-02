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
        if let index = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: index, animated: true)
        }
        if tableData.isEmpty {
            makeRequestForBasicInfo()
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        networkHandler.cancelRequest()
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let cell = sender as? BasicHotelInfoTableViewCell,
           let index = tableView.indexPath(for: cell),
           let vc = segue.destination as? FullInfoViewController {
            vc.basicHotelInfo = tableData[index.row]
            vc.navigationItem.title = tableData[index.row].name
        }
    }

    // MARK: - Utility functions
    private func makeRequestForBasicInfo() {
        activityIndicator.startAnimating()
        networkHandler.makeRequestForBasicInfo { [weak self] error, data in
            DispatchQueue.main.async {
                guard let self = self else {
                    return
                }
                self.activityIndicator.stopAnimating()
                if let error = error {
                    self.showErrorAlert(with: error)
                }
                if let data = data {
                    self.tableData = data
                    self.tableView.reloadData()
                    self.tableView.isHidden = false
                }
            }
        }
    }

    private func showErrorAlert(with message: String) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
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
