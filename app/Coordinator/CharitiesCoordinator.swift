//
//  CharitiesCoordinator.swift
//  app
//
//  Created by Hamed Ghadirian on 24.10.19.
//  Copyright © 2019 Hamed.Gh. All rights reserved.
//

import Foundation
import UIKit

class CharitiesCoordinator : Coordinator {
    var navigationController: CoordinatedNavigationController
    
    init(navigationController: CoordinatedNavigationController = CoordinatedNavigationController()) {
        self.navigationController = navigationController
        navigationController.coordinator = self

        let charitiesViewController = CharityListViewController()
        let img = UIImage(named: AppImages.Charities)
        charitiesViewController.tabBarItem = UITabBarItem(title: "Charities", image: img, tag: 0)
        
        navigationController.viewControllers = [charitiesViewController]

    }
}
