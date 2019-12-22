//
//  BasicInfoViewController.swift
//  HotelsTestTask
//
//  Created by Alexander Ershov on 30.11.2019.
//  Copyright © 2019 Alexander Ershov. All rights reserved.
//

import UIKit


/// Shows table with basic info for all hotels
class BasicInfoViewController: UIViewController {

    // MARK: - VIPER parts
    var presenter: BasicInfoPresenterProtocol!
    private let configurator: BasicInfoConfiguratorProtocol = BasicInfoConfigurator()

    // MARK: - IBOutlets
    @IBOutlet weak private var tableView: UITableView!
    @IBOutlet weak private var activityIndicator: UIActivityIndicatorView!

    // MARK: - IBActions
    @IBAction private func sortByDistanceToTheCentre(_ sender: UIBarButtonItem) {
        presenter.sortByDistanceTapped()
    }

    @IBAction private func sortByNumberOfAvailableSuits(_ sender: UIBarButtonItem) {
        presenter.sortByNumberOfSuitsTapped()
    }

    // MARK: - View controller life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self

        configurator.configure(with: self)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.viewDidAppear()
        if let index = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: index, animated: true)
        }
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        presenter.viewDidDisappear()
    }
}

// MARK: - BasicInfoViewProtocol
extension BasicInfoViewController: BasicInfoViewProtocol {
    func updateTableView() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }

    func runActivityIndicator() {
        DispatchQueue.main.async {
            self.activityIndicator.startAnimating()
        }
    }

    func stopActivityIndicator() {
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
        }
    }
}

// MARK: - UITableViewDataSource
extension BasicInfoViewController: UITableViewDataSource {
    private var tableViewCellId: String {
        "BasicHotelInfoCell"
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter.numberOfHotels
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: tableViewCellId, for: indexPath)
        guard let basicInfoCell = cell as? BasicInfoTableViewCell else {
            return cell
        }
        presenter.configure(cell: basicInfoCell, at: indexPath)
        return basicInfoCell
    }
}

// MARK: - UITableViewDelegate
extension BasicInfoViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.tableViewCellTapped(at: indexPath)
    }
}
