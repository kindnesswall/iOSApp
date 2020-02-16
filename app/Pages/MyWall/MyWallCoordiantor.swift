//
//  MyWallCoordiantor.swift
//  app
//
//  Created by Hamed Ghadirian on 28.10.19.
//  Copyright © 2019 Hamed.Gh. All rights reserved.
//

import Foundation
import UIKit

class MyWallCoordinator: NavigationCoordinator {
    let keychainService = KeychainService()
    var navigationController: CoordinatedNavigationController
    
    lazy var giftDetailCoordinator = GiftDetailCoordinator(navigationController: self.navigationController)

    init() {
        self.navigationController = CoordinatedNavigationController()
        navigationController.coordinator = self
        let img = UIImage(named: AppImages.MyWall)
        navigationController.tabBarItem = UITabBarItem(title: LanguageKeys.tabBarMyWall.localizedString, image: img, tag: 0)
        
    }
    
    init(navigationController: CoordinatedNavigationController) {
        self.navigationController = navigationController
    }

    func showMyWall() {
        let viewController = MyWallViewController(myWallCoordinator: self)
        let myId = Int(keychainService.getString(.userId) ?? "")
        viewController.userId = myId
        navigationController.viewControllers = [viewController]
    }
    
    func pushContactWall(contactId: Int) {
        let viewController = MyWallViewController(myWallCoordinator: self)
        viewController.userId = contactId
        navigationController.pushViewController(viewController, animated: true)
    }

    func showGiftDetail(gift: Gift, editHandler:(() -> Void)?) {
        giftDetailCoordinator.showGiftDetailOf(gift, editHandler: editHandler)
    }
}
