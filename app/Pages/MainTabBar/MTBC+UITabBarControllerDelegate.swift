//
//  MTBC+UITabBarControllerDelegate.swift
//  app
//
//  Created by Hamed Ghadirian on 22.10.19.
//  Copyright © 2019 Hamed.Gh. All rights reserved.
//

import Foundation
import UIKit

extension MainTabBarController : UITabBarControllerDelegate{
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        
        if !isUserLogedIn(),authIsMandatory(for: viewController)
            {
            showLoginVC()
            return false
        }
        
        
        return true
        
    }
    private func authIsMandatory(for viewController:UIViewController)->Bool {
        guard let vc = (viewController as? UINavigationController)?.viewControllers.first else {
            return false
        }
        
        if
            vc as? RegisterGiftViewController != nil
            ||
            vc as? MyWallViewController != nil
            ||
            vc as? ContactsViewController != nil
        {
            return true
        }
        
        return false
    }
}
