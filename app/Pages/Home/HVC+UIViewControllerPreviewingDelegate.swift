//
//  HVC+UIViewControllerPreviewingDelegate.swift
//  app
//
//  Created by Hamed.Gh on 1/1/19.
//  Copyright © 2019 Hamed.Gh. All rights reserved.
//

import UIKit

extension HomeViewController: UIViewControllerPreviewingDelegate {
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {

        if let indexPath = tableview.indexPathForRow(at: location) {
            previewRowIndex = indexPath.row

            previewingContext.sourceRect = tableview.rectForRow(at: indexPath)
            return homeCoordiantor?.getGiftDetailVCFor(vm.gifts[indexPath.row], self.editHandler)
        }

        return nil
    }

    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        self.navigationController?.pushViewController(viewControllerToCommit, animated: true)
    }
}
