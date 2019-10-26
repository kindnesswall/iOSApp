//
//  ChatCoordinator.swift
//  app
//
//  Created by Hamed Ghadirian on 25.10.19.
//  Copyright © 2019 Hamed.Gh. All rights reserved.
//

import Foundation
import UIKit

class ChatCoordinator : Coordinator {
    var navigationController: CoordinatedNavigationController
    
    init(navigationController: CoordinatedNavigationController = CoordinatedNavigationController()) {
        self.navigationController = navigationController
        navigationController.coordinator = self

        let viewController = ContactsViewController()
        let img = UIImage(named: AppImages.Contacts)
        viewController.tabBarItem = UITabBarItem(title: "Chat", image: img, tag: 0)
        
        navigationController.viewControllers = [viewController]
    }
}
