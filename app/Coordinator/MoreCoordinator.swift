//
//  MoreCoordinator.swift
//  app
//
//  Created by Hamed Ghadirian on 25.10.19.
//  Copyright © 2019 Hamed.Gh. All rights reserved.
//

import Foundation
import UIKit

class MoreCoordinator : Coordinator {
    var navigationController: CoordinatedNavigationController
    
    init(navigationController: CoordinatedNavigationController = CoordinatedNavigationController()) {
        self.navigationController = navigationController
        navigationController.coordinator = self

        let viewController = MoreViewController()
        let img = UIImage(named: AppImages.More)
        viewController.tabBarItem = UITabBarItem(title: "More", image: img, tag: 0)
        
        navigationController.viewControllers = [viewController]
    }
}
