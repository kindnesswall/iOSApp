//
//  ContactsViewModel+DataSource.swift
//  app
//
//  Created by Hamed Ghadirian on 29.10.19.
//  Copyright © 2019 Hamed.Gh. All rights reserved.
//

import Foundation
import UIKit

extension ContactsViewModel : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.allChats.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(type: ChatTableViewCell.self, for: indexPath)
        let messagesViewModel = self.allChats[indexPath.row]
        cell.fillUI(viewModel: messagesViewModel)
        return cell
    }
}
