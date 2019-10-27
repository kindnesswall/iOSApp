//
//  HVC+UITableViewDelegate.swift
//  app
//
//  Created by Hamed.Gh on 1/1/19.
//  Copyright © 2019 Hamed.Gh. All rights reserved.
//

import UIKit

extension HomeViewController:UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        guard vm.isReview else {return UISwipeActionsConfiguration(actions: [])}
        let approveAction = approveGift(at: indexPath)
        return UISwipeActionsConfiguration(actions: [approveAction])
    }

    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        guard vm.isReview else {return UISwipeActionsConfiguration(actions: [])}
        let rejectAction = rejectGift(at: indexPath)
        return UISwipeActionsConfiguration(actions: [rejectAction])
    }

    func approveGift(at indexPath: IndexPath) -> UIContextualAction {
        let action = UIContextualAction(style: .normal, title: "Approve") { (uiContextualAction, view, completion) in
            self.approveAction(rowIndex: indexPath,handler: completion)
        }
        action.image = UIImage(named: AppImages.Approve)
        action.backgroundColor = .green
        return action
    }

    func approveAction(rowIndex: IndexPath,handler: @escaping (Bool)->()) {
        self.vm.giftApprovedAfterReview(rowNumber: rowIndex.row, completion: { [weak self] (result) in
            switch result {
            case .failure(_):
                self?.showDialogFailed {
                    self?.approveAction(rowIndex: rowIndex, handler: handler)
                }
            case .success:
                DispatchQueue.main.async {
                    self?.tableview.deleteRows(at: [rowIndex], with: .automatic)
                }
                handler(true)
            }
        })
    }
    
    func rejectGift(at indexPath: IndexPath) -> UIContextualAction {
        let action = UIContextualAction(style: .destructive, title: "Reject") { [weak self](uiContextualAction, view, completion) in
            self?.showConfirmationDialog {
                self?.rejectAction(rowIndex: indexPath, handler: completion)
            }
        }
        action.image = UIImage(named: AppImages.Reject)
        //        action.backgroundColor = .red
        return action
    }
    
    func rejectAction(rowIndex: IndexPath,handler: @escaping (Bool)->()) {
        self.vm.giftRejectedAfterReview(rowNumber: rowIndex.row, completion: { [weak self] (result) in
            switch result {
            case .failure(_):
                self?.showDialogFailed {
                    self?.rejectAction(rowIndex: rowIndex, handler: handler)
                }
            case .success:
                DispatchQueue.main.async {
                    self?.tableview.deleteRows(at: [rowIndex], with: .automatic)
                }
                handler(true)
            }
        })
    }
    
    func showDialogFailed(tryAgainHandler: @escaping ()-> Void) {
        let alert = UIAlertController(
            title:LocalizationSystem.getStr(forKey: LanguageKeys.requestfail_dialog_title),
            message: LocalizationSystem.getStr(forKey: LanguageKeys.requestfail_dialog_text),
            preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(
            UIAlertAction(
                title: LocalizationSystem.getStr(forKey: LanguageKeys.tryAgain),
                style: UIAlertAction.Style.default, handler: { (action) in
                    tryAgainHandler()
            }))
        
        alert.addAction(
            UIAlertAction(
                title: LocalizationSystem.getStr(forKey: LanguageKeys.cancel),
                style: UIAlertAction.Style.default, handler: { (action) in
                    alert.dismiss(animated: true, completion: nil)
            }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func showConfirmationDialog(actionHandler: @escaping ()-> Void) {
        let alert = UIAlertController(
            title:LocalizationSystem.getStr(forKey: LanguageKeys.warning),
            message: LocalizationSystem.getStr(forKey: LanguageKeys.areYouSure),
            preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(
            UIAlertAction(
                title: LocalizationSystem.getStr(forKey: LanguageKeys.yes),
                style: UIAlertAction.Style.default, handler: { (action) in
                    actionHandler()
            }))
        
        alert.addAction(
            UIAlertAction(
                title: LocalizationSystem.getStr(forKey: LanguageKeys.cancel),
                style: UIAlertAction.Style.default, handler: { (action) in
                    alert.dismiss(animated: true, completion: nil)
            }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        homeCoordiantor?.showDetail(gift: vm.gifts[indexPath.row], editHandler: self.editHandler)
    }
    
    func editHandler(){
        self.reloadPage()
        reloadOtherVCs()
    }
    
    func reloadOtherVCs(){
        AppDelegate.me().appCoordinator.reloadTabBarPages(currentPage: self)
    }
    
}

