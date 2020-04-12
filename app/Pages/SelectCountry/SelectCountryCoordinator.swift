//
//  SelectCountryCoordinator.swift
//  app
//
//  Created by Amir Hossein on 3/11/20.
//  Copyright © 2020 Hamed.Gh. All rights reserved.
//

import UIKit

class SelectCountryCoordinator: NavigationCoordinator, NetworkAlertCoordinator {
    var navigationController: CoordinatedNavigationController
    
    init(presentedAtLaunch: Bool) {
        self.navigationController = CoordinatedNavigationController()
        navigationController.coordinator = self
        let controller = SelectCountryVC(coordinator: self, presentedAtLaunch: presentedAtLaunch)
        navigationController.viewControllers = [controller]
    }
}
