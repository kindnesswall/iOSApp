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
    var tabBarController:UITabBarController
//    var navigationController: UINavigationController
//
    init(tabBarController: UITabBarController) {
        self.tabBarController = tabBarController
//        self.navigationController = tabBarController.navigationController ?? <#default value#>
    }

    func start() {
        
    }
    
    func showLockVC() {
        let controller = LockViewController()
        controller.mode = .CheckPassCode
        controller.isCancelable = false
        self.tabBarController.present(controller, animated: true, completion: nil)
    }
    
    func showIntro() {
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = mainStoryboard.instantiateViewController(withIdentifier: IntroViewController.identifier) as! IntroViewController
        self.tabBarController.present(viewController, animated: true, completion: nil)        
    }
}
