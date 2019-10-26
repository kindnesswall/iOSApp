//
//  TabBarController.swift
//  app
//
//  Created by Hamed Ghadirian on 22.10.19.
//  Copyright © 2019 Hamed.Gh. All rights reserved.
//

import Foundation
import UIKit
import KeychainSwift

class TabBarController : UITabBarController{
    weak var startNewChatProtocol:StartNewChatProtocol?
    weak var refreshChatProtocol:RefreshChatProtocol?
    let keychain = KeychainSwift()
    
    lazy var tabBarCoordinator:TabBarCoordinator = TabBarCoordinator(tabBarController: self)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBarCoordinator.initializeTabs()
    }
    
}


