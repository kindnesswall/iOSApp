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

    lazy var apiRequest = ApiRequest(HTTPLayer())

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = LocalizationSystem.getStr(forKey: "StatisticViewController_title")

        self.tableView.register(type: StatisticTableViewCell.self)
        self.initialLoadingIndicator=LoadingIndicator(view: self.view)

        fetchStatistics()
        // Do any additional setup after loading the view.
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

        let input: APIEmptyInput? = nil

        apiRequest.getStatistics { [weak self](result) in

            self?.statisticsKeys = []
            self?.statisticsValues = []
            self?.stopLoadingPage()

            switch result {
            case .failure(let appError):
                print("Error")
            case .success(let statisticsData):
                print(statisticsData)
                if let statistics = statisticsData.statistics {
                    for (key, value) in statistics {
                        self?.statisticsKeys.append(key)
                        self?.statisticsValues.append(value)
                    }
                    self?.tableView.reloadData()
                }
            }
        }
//        APICall.request(url: APIURLs.getStatistics, httpMethod: .GET, input: input) { [weak self] (data, response, error)  in
//            APICall.printData(data: data)

//            self?.statisticsKeys = []
//            self?.statisticsValues = []
//            self?.stopLoadingPage()
//
//            if let statisticsData = APICall.readJsonData(data: data, outputType: Statistics.self) {
//                if let statistics = statisticsData.statistics {
//                    for (key , value) in statistics {
//                        self?.statisticsKeys.append(key)
//                        self?.statisticsValues.append(value)
//                    }
//                    self?.tableView.reloadData()
//                }
//
//            }
//        }

    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
