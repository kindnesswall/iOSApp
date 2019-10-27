//
//  HVC+HomeViewModelDelegate.swift
//  app
//
//  Created by Hamed.Gh on 1/1/19.
//  Copyright © 2019 Hamed.Gh. All rights reserved.
//

import UIKit

protocol HomeViewModelDelegate: class {
    func pageLoadingAnimation(isLoading:Bool)
    func lazyLoadingAnimation(isLoading:Bool)
    func refreshControlAnimation(isLoading:Bool)
    func showTableView(show:Bool)
    func reloadTableView()
    func insertNewItemsToTableView(insertedIndexes:[IndexPath])
    func presentfailedAlert(alert:UIAlertController)
}

extension HomeViewController : HomeViewModelDelegate {

    func insertNewItemsToTableView(insertedIndexes:[IndexPath]) {
        UIView.performWithoutAnimation {
            self.tableview.insertRows(at: insertedIndexes, with: .bottom)
        }
    }
    
    func reloadTableView() {
        self.tableview.reloadData()
    }
    
    func pageLoadingAnimation(isLoading:Bool) {
        if isLoading {
            hud.show(in: self.view)
        } else {
            self.hud.dismiss(afterDelay: 0)
        }
    }
    
    func lazyLoadingAnimation(isLoading:Bool) {
        self.setTableViewLazyLoading(isLoading: isLoading)
    }
    
    func refreshControlAnimation(isLoading:Bool) {
        if isLoading {
            
        } else {
            self.refreshControl.endRefreshing()
        }
    }
    
    func showTableView(show:Bool){
        if show {
            self.tableview.show()
        } else {
            self.tableview.hide()
        }
    }
    
    func presentfailedAlert(alert:UIAlertController) {
        self.present(alert, animated: true, completion: nil)
    }
}
