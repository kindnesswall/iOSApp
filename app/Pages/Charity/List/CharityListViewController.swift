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
    var vm = CharityListViewModel()
    
    @IBAction func addNewCharityClicked(_ sender: Any) {
        //Todo: should browse to the telegram account to contact us or charity app in app store
        print("Navigate to telegram or charity app")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableview.register(type: CharityTableViewCell.self)
        
        tableview.dataSource = vm
        tableview.delegate = self
        
        vm.getList {[weak self] in
            DispatchQueue.main.async {
                self?.tableview.reloadData()
            }
        }
    }

}

extension CharityListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let charityDetailVM = CharityDetailViewModel(charity: vm.charities[indexPath.row])
        let controller = CharityDetailViewController(vm: charityDetailVM)
        self.navigationController?.pushViewController(controller, animated: true)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CharityTableViewCell.cellHeight
    }
}

