//
//  MyWallCoordiantor.swift
//  app
//
//  Created by Hamed Ghadirian on 28.10.19.
//  Copyright © 2019 Hamed.Gh. All rights reserved.
//

import Foundation
import UIKit
import KeychainSwift

class MyWallCoordinator : NavigationCoordinator {
    var navigationController: CoordinatedNavigationController
    
    init(navigationController: CoordinatedNavigationController = CoordinatedNavigationController()) {
        self.navigationController = navigationController
        navigationController.coordinator = self
    }
    
    func showMyWall() {
        let viewController = MyWallViewController(myWallCoordinator: self)
        viewController.userId = Int(KeychainSwift().get(AppConst.KeyChain.USER_ID) ?? "")
        
        let img = UIImage(named: AppImages.MyWall)
        viewController.tabBarItem = UITabBarItem(title: LanguageKeys.tabBar_my_wall.localizedString, image: img, tag: 0)
        
        navigationController.viewControllers = [viewController]
    }
    
    func showGiftDetail(gift: Gift, editHandler:(()->Void)?) {
        let controller = GiftDetailViewController()
        
        controller.gift = gift
        controller.editHandler = editHandler
        
        self.navigationController.pushViewController(controller, animated: true)
    }
}
