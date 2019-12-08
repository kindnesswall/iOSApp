//
//  DonateGiftCoordinator.swift
//  app
//
//  Created by Hamed Ghadirian on 25.10.19.
//  Copyright © 2019 Hamed.Gh. All rights reserved.
//

import Foundation
import UIKit

class DonateGiftCoordinator: NavigationCoordinator {
    var navigationController: CoordinatedNavigationController

    init(navigationController: CoordinatedNavigationController = CoordinatedNavigationController()) {
        self.navigationController = navigationController
        navigationController.coordinator = self

        let viewController = RegisterGiftViewController()
        let img = UIImage(named: AppImages.DonateGift)
        viewController.tabBarItem = UITabBarItem(title: LanguageKeys.tabBarGiveGift.localizedString, image: img, tag: 0)

        navigationController.viewControllers = [viewController]
    }
}
