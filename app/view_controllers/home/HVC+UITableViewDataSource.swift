//
//  HVC+UITableViewDataSource.swift
//  app
//
//  Created by Hamed.Gh on 1/1/19.
//  Copyright © 2019 Hamed.Gh. All rights reserved.
//

import UIKit

extension HomeViewController:UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.vm.gifts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if AppDelegate.me().isIranSelected(){
            let index=indexPath.row+1
            if index==self.vm.gifts.count {
                if !self.vm.isLoadingGifts {
                    if let beforeId = self.vm.gifts[indexPath.row].id {
                        vm.getGifts(beforeId: beforeId)
                    }
                }
            }
        }
        
        if let isAd = vm.gifts[indexPath.row].isAd, isAd {
            let cell=tableView.dequeueReusableCell(
                withIdentifier: GiftAdCell.identifier) as! GiftAdCell
            
            cell.setOnClickBtn {
                AppDelegate.me().shareApp()
            }
            
            cell.showAd()//index: index, vc: self)
            
            return cell
        }else{
            let cell=tableView.dequeueReusableCell(withIdentifier: GiftTableViewCell.identifier) as! GiftTableViewCell
            
            cell.filViews(gift: vm.gifts[indexPath.row])
            return cell
        }
        
    }
    
    func getGiftDetailVCFor(index:Int) -> UIViewController {
        let controller = GiftDetailViewController()
        
        controller.gift = vm.gifts[index]
        controller.editHandler={ [weak self] in
            self?.editHandler()
        }
        print("Gift_id: \(controller.gift?.id?.description ?? "")")
        
        return controller
    }
}

