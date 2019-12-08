//
//  HomeCoordinator.swift
//  app
//
//  Created by Hamed Ghadirian on 24.10.19.
//  Copyright © 2019 Hamed.Gh. All rights reserved.
//

import Foundation
import UIKit

class HomeCoordinator: NavigationCoordinator {
    var navigationController: CoordinatedNavigationController
    var homeViewController: HomeViewController?

    lazy var giftDetailCoordinator = GiftDetailCoordinator(navigationController: self.navigationController)
    var isReview: Bool

    init(navigationController: CoordinatedNavigationController = CoordinatedNavigationController(), isReview: Bool = false) {
        self.isReview = isReview
        self.navigationController = navigationController
        navigationController.coordinator = self
    }

    func showHome() {
        homeViewController = HomeViewController(vm: HomeVM(), homeCoordiantor: self)

        let img = UIImage(named: AppImages.Home)
        homeViewController?.tabBarItem = UITabBarItem(title: LanguageKeys.home.localizedString, image: img, tag: 0)

        if let vc = homeViewController {
            navigationController.viewControllers = [vc]
        }
    }

    func pushRoot() {
        homeViewController = HomeViewController(vm: HomeVM(isReview: isReview), homeCoordiantor: self)
        navigationController.pushViewController(homeViewController!, animated: true)
    }

    func showDetail(gift: Gift, editHandler:(() -> Void)?) {
        giftDetailCoordinator.showGiftDetailOf(gift, editHandler: editHandler)
    }

    func getGiftDetailVCFor(_ gift: Gift, _ editHandler:(() -> Void)?) -> UIViewController {
        return giftDetailCoordinator.getGiftDetailVCFor(gift, editHandler)
    }

    func showDialogFailed(tryAgainHandler: @escaping () -> Void) {
        let alert = UIAlertController(
            title: LanguageKeys.requestfailDialogTitle.localizedString,
            message: LanguageKeys.requestfailDialogText.localizedString,
            preferredStyle: UIAlertController.Style.alert)

        alert.addAction(
            UIAlertAction(
                title: LanguageKeys.tryAgain.localizedString,
                style: UIAlertAction.Style.default, handler: { (_) in
                    tryAgainHandler()
            }))

        alert.addAction(
            UIAlertAction(
                title: LanguageKeys.cancel.localizedString,
                style: UIAlertAction.Style.default, handler: { (_) in
                    alert.dismiss(animated: true, completion: nil)
            }))

        self.navigationController.present(alert, animated: true, completion: nil)
    }

    func showConfirmationDialog(actionHandler: @escaping () -> Void) {
        let alert = UIAlertController(
            title: LanguageKeys.warning.localizedString,
            message: LanguageKeys.areYouSure.localizedString,
            preferredStyle: UIAlertController.Style.alert)

        alert.addAction(
            UIAlertAction(
                title: LanguageKeys.yes.localizedString,
                style: UIAlertAction.Style.default, handler: { (_) in
                    actionHandler()
            }))

        alert.addAction(
            UIAlertAction(
                title: LanguageKeys.cancel.localizedString,
                style: UIAlertAction.Style.default, handler: { (_) in
                    alert.dismiss(animated: true, completion: nil)
            }))

        self.navigationController.present(alert, animated: true, completion: nil)
    }

    func reloadOtherVCs() {
        if let vc = homeViewController {
            AppDelegate.me().appCoordinator.reloadTabBarPages(currentPage: vc)
        }
    }
}
