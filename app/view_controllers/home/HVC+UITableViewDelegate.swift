//
//  HVC+UITableViewDelegate.swift
//  app
//
//  Created by Hamed.Gh on 1/1/19.
//  Copyright © 2019 Hamed.Gh. All rights reserved.
//

import UIKit

extension HomeViewController:UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let controller = getGiftDetailVCFor(index: indexPath.row)
        
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func editHandler(){
        self.reloadPage()
        reloadOtherVCs()
    }
    
    func reloadOtherVCs(){
        AppDelegate.me().reloadTabBarPages(currentPage: self)
    }
    
}

