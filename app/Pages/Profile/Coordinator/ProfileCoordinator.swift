//
//  ProfileCoordinator.swift
//  app
//
//  Created by Amir Hossein on 3/10/20.
//  Copyright © 2020 Hamed.Gh. All rights reserved.
//

import UIKit

class ProfileCoordinator: NavigationCoordinator, NetworkAlertCoordinator {
    var navigationController: CoordinatedNavigationController
    
    init() {
        self.navigationController = CoordinatedNavigationController()
        navigationController.coordinator = self
        let controller = ProfileViewController(coordinator: self)
        navigationController.viewControllers = [controller]
    }
}


