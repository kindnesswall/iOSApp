//
//  HVC+UIViewControllerPreviewingDelegate.swift
//  app
//
//  Created by Hamed.Gh on 1/1/19.
//  Copyright © 2019 Hamed.Gh. All rights reserved.
//

import UIKit

extension HomeViewController:UIViewControllerPreviewingDelegate{
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        
        if let indexPath = tableview.indexPathForRow(at: location) {
            previewRowIndex = indexPath.row
            guard !(vm.gifts[indexPath.row].isAd ?? false) else {
                return nil
            }
            
            previewingContext.sourceRect = tableview.rectForRow(at: indexPath)
            return getGiftDetailVCFor(index: indexPath.row)
        }
        
        return nil
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        
        if let index = previewRowIndex, vm.gifts[index].isAd == nil || vm.gifts[index].isAd == false {
            previewRowIndex = nil
            if let ad = self.videoInterstitialAd, self.isMoreThanOneDayIDidntSawAd()
            {
                self.show(ad:ad)
                return
            }
        }
        self.navigationController?.pushViewController(viewControllerToCommit, animated: true)
    }
}

