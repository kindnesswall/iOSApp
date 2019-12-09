//
//  TabBarController.swift
//  app
//
//  Created by Hamed Ghadirian on 22.10.19.
//  Copyright © 2019 Hamed.Gh. All rights reserved.
//

import Foundation
import UIKit

class TabBarController: UITabBarController {

    let keychainService = KeychainService()
    let tabBarViewModel = TabBarViewModel()

    var tabBarCoordinator: TabBarCoordinator?

    init(tabBarCoordinator: TabBarCoordinator) {
        self.tabBarCoordinator = tabBarCoordinator
        super.init(nibName: nil, bundle: nil)
        self.delegate = self
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
//
//    func refreshAppAfterSwitchUser(){
//        tabBarCoordinator?.refreshAppAfterSwitchUser()
//    }

//    func logout(){
//        AppDelegate.me().appViewModel.clearUserSensitiveData()
//        tabBarCoordinator?.refreshAppAfterSwitchUser()
//    }

}

extension TabBarController: UITabBarControllerDelegate {

    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {

        if !keychainService.isUserLogedIn(), tabBarViewModel.isAuthenticationMandatory(for: viewController) {
                tabBarCoordinator?.showLoginView()
            return false
        }

        return true

    }

}
