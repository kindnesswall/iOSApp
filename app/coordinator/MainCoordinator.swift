//
//  MainCoordinator.swift
//  app
//
//  Created by Hamed Ghadirian on 22.10.19.
//  Copyright © 2019 Hamed.Gh. All rights reserved.
//

import Foundation
import UIKit

class MainCoordinator: Coordinator {
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    public var tabBarController:UITabBarController?

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        
    }
    
}
