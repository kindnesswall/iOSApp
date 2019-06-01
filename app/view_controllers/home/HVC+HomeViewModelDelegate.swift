//
//  HVC+HomeViewModelDelegate.swift
//  app
//
//  Created by Hamed.Gh on 1/1/19.
//  Copyright © 2019 Hamed.Gh. All rights reserved.
//

import UIKit

extension HomeViewController : HomeViewModelDelegate {
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let approveAction = approveGift(at: indexPath)
        return UISwipeActionsConfiguration(actions: [approveAction])
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let rejectAction = rejectGift(at: indexPath)
        return UISwipeActionsConfiguration(actions: [rejectAction])
    }
    
    func approveGift(at indexPath: IndexPath) -> UIContextualAction {
        let action = UIContextualAction(style: .normal, title: "Approve") { (uiContextualAction, view, completion) in
            self.vm.gifts.remove(at: indexPath.row)
            self.tableview.deleteRows(at: [indexPath], with: .automatic)
            completion(true)
        }
        action.image = UIImage(named: "approve")
        action.backgroundColor = .green
        return action
    }
    
    func rejectGift(at indexPath: IndexPath) -> UIContextualAction {
        let action = UIContextualAction(style: .destructive, title: "Reject") { (uiContextualAction, view, completion) in
            self.vm.gifts.remove(at: indexPath.row)
            self.tableview.deleteRows(at: [indexPath], with: .automatic)
            completion(true)
        }
        action.image = UIImage(named: "reject")
        action.backgroundColor = .red
        return action
    }
    
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
