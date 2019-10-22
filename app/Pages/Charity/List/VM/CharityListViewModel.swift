//
//  CharityListViewModel.swift
//  app
//
//  Created by Hamed Ghadirian on 01.09.19.
//  Copyright © 2019 Hamed.Gh. All rights reserved.
//

import UIKit
import Kingfisher

class CharityListViewModel:NSObject {
    var charities:[Charity] = []
    
    lazy var httpLayer = HTTPLayer()
    lazy var apiService = ApiService(httpLayer)

    func getList(compeletionHandler: @escaping ()->()) {
        apiService.getCharityList { [weak self](result) in
            switch(result){
            case .failure(let error):
                print(error)
            case.success(let charities):
                self?.charities.append(contentsOf: charities)
            }
            compeletionHandler()
        }
    }
}

extension CharityListViewModel: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return charities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(type: CharityTableViewCell.self, for: indexPath)
        let charity = charities[indexPath.row]
        cell.titleLabel.text = charity.name
        cell.subtitleLabel.text = charity.manager
        if let path = charity.imageUrl {
            cell.imageview.kf.setImage(with: URL(string: path), placeholder: UIImage(named: AppImages.BlankAvatar))
        }
        
        return cell
    }
}
