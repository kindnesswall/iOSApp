//
//  StatisticViewController.swift
//  app
//
//  Created by Amir Hossein on 8/24/18.
//  Copyright © 2018 Hamed.Gh. All rights reserved.
//

import UIKit

class StatisticViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var statisticsKeys = [String]()
    var statisticsValues = [Int]()

    @IBOutlet weak var tableView: UITableView!
    var initialLoadingIndicator: LoadingIndicator?

    lazy var apiService = ApiService(HTTPLayer())

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "StatisticViewController_title".localizedString

        self.tableView.register(type: StatisticTableViewCell.self)
        self.initialLoadingIndicator=LoadingIndicator(view: self.view)

        fetchStatistics()
    }

    func startLoadingPage() {
        self.initialLoadingIndicator?.startLoading()
        self.tableView.hide()
    }
    func stopLoadingPage() {
        self.initialLoadingIndicator?.stopLoading()
        self.tableView.show()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.navigationController?.navigationBar.setDefaultStyle()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return statisticsKeys.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(type: StatisticTableViewCell.self, for: indexPath)
        cell.setUI(key: self.statisticsKeys[indexPath.item], value: AppLanguage.getNumberString(number: self.statisticsValues[indexPath.item].description))
        return cell
    }

    func fetchStatistics() {

        startLoadingPage()

        apiService.getStatistics { [weak self](result) in

            self?.statisticsKeys = []
            self?.statisticsValues = []
            DispatchQueue.main.async {
                self?.stopLoadingPage()
            }

            switch result {
            case .failure(let appError):
                print("Error \(appError)")
            case .success(let statisticsData):

                if let statistics = statisticsData {
                    for (key, value) in statistics {
                        self?.statisticsKeys.append(key)
                        self?.statisticsValues.append(value)
                    }
                    DispatchQueue.main.async {
                        self?.tableView.reloadData()
                    }
                }
            }
        }
    }
}
