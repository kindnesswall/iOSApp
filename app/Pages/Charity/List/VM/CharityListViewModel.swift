//
//  CharityListViewModel.swift
//  app
//
//  Created by Hamed Ghadirian on 01.09.19.
//  Copyright © 2019 Hamed.Gh. All rights reserved.
//

import UIKit

class CharityListViewModel:NSObject {
    
}

extension CharityListViewModel: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(type: CharityTableViewCell.self, for: indexPath)
        cell.titleLabel.text = "test"
        return cell
    }
}
