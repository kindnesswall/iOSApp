//
//  HomeVM+UITableViewDataSource.swift
//  app
//
//  Created by Hamed Ghadirian on 02.06.19.
//  Copyright © 2019 Hamed.Gh. All rights reserved.
//

import UIKit

extension HomeVM: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.gifts.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let index=indexPath.row+1
        if index==self.gifts.count {
            if !self.isLoadingGifts {
                if let beforeId = self.gifts[indexPath.row].id {
                    getGifts(beforeId: beforeId)
                }
            }
        }

        let cell=tableView.dequeue(type: GiftTableViewCell.self, for: indexPath)
        cell.filViews(gift: gifts[indexPath.row])
        return cell

    }
}
