//
//  HomeCoordinator.swift
//  app
//
//  Created by Hamed Ghadirian on 24.10.19.
//  Copyright © 2019 Hamed.Gh. All rights reserved.
//

import Foundation
import UIKit

class HomeCoordinator : Coordinator {
    var navigationController: CoordinatedNavigationController
    
    init(navigationController: CoordinatedNavigationController = CoordinatedNavigationController()) {
        self.navigationController = navigationController
        navigationController.coordinator = self

        let viewController = HomeViewController(vm: HomeVM())
        let img = UIImage(named: AppImages.Home)
        viewController.tabBarItem = UITabBarItem(title: "Home", image: img, tag: 0)
        
        navigationController.viewControllers = [viewController]
    }
}

