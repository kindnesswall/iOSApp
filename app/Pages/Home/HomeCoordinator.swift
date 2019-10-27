//
//  HomeCoordinator.swift
//  app
//
//  Created by Hamed Ghadirian on 24.10.19.
//  Copyright © 2019 Hamed.Gh. All rights reserved.
//

import Foundation
import UIKit

class HomeCoordinator : NavigationCoordinator {
    var navigationController: CoordinatedNavigationController
    lazy var giftDetailCoordinator = GiftDetailCoordinator(navigationController: self.navigationController)
    
    init(navigationController: CoordinatedNavigationController = CoordinatedNavigationController()) {
        self.navigationController = navigationController
        navigationController.coordinator = self
    }
    
    func showHome() {
        let viewController = HomeViewController(vm: HomeVM(), homeCoordiantor: self)
        
        let img = UIImage(named: AppImages.Home)
        viewController.tabBarItem = UITabBarItem(title: "Home", image: img, tag: 0)
        
        navigationController.viewControllers = [viewController]
    }
    
    func showDetail(gift:Gift, editHandler:(()->Void)?) {
        giftDetailCoordinator.showGiftDetailOf(gift, editHandler: editHandler)
    }
    
    func getGiftDetailVCFor(_ gift:Gift,_ editHandler:(()->Void)?) -> UIViewController {
        return giftDetailCoordinator.getGiftDetailVCFor(gift, editHandler)
    }
}

