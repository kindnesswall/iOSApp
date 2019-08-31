//
//  CharityListViewController.swift
//  app
//
//  Created by Hamed Ghadirian on 10.07.19.
//  Copyright © 2019 Hamed.Gh. All rights reserved.
//

import UIKit

class CharityListViewController: UIViewController {

    @IBOutlet weak var tableview: UITableView!
    
    @IBAction func addNewCharityClicked(_ sender: Any) {
        //Todo: should browse to the telegram account to contact us or charity app in app store
        print("Navigate to telegram or charity app")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableview.register(type: CharityTableViewCell.self)
        
        tableview.dataSource = self
        tableview.delegate = self
        
    }

}

extension CharityListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CharityTableViewCell.cellHeight
    }
}

extension CharityListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableview.dequeue(type: CharityTableViewCell.self, for: indexPath)
        cell.titleLabel.text = "test"
        return cell
    }

}
