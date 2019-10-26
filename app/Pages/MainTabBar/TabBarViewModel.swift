//
//  TabBarViewModel.swift
//  app
//
//  Created by Hamed Ghadirian on 26.10.19.
//  Copyright © 2019 Hamed.Gh. All rights reserved.
//

import Foundation
import UIKit

class TabBarViewModel {
    
    func isAuthenticationMandatory(for viewController:UIViewController)->Bool {
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
