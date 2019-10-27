//
//  AppCoordinator.swift
//  app
//
//  Created by Hamed Ghadirian on 22.10.19.
//  Copyright © 2019 Hamed.Gh. All rights reserved.
//

import Foundation
import UIKit

protocol AppCoordinatorProtocol {
    var window: UIWindow { get set }
}

class AppCoordinator:AppCoordinatorProtocol {
    var window: UIWindow
    var tabBarCoordinator:TabBarCoordinator?
    
    init(with window:UIWindow = UIWindow() ) {
        self.window = window
    }
    
    func reloadTabBarPages(currentPage: ReloadablePage?){
        tabBarCoordinator?.reloadTabBarPages(currentPage: currentPage)
    }
    
    func refreshAppAfterSwitchUser() {
        tabBarCoordinator?.refreshAppAfterSwitchUser()
    }
    
    func showRootView() {
        tabBarCoordinator = TabBarCoordinator(appCoordinator: self)
        window.makeKeyAndVisible()
        window.rootViewController = self.tabBarCoordinator?.tabBarController
    }
    
    func checkForLogin()->Bool{
        return tabBarCoordinator?.checkForLogin() ?? false
    }
    
    func showRegisterGiftTab() {
        tabBarCoordinator?.setSelectedTab(index: AppConst.TabIndex.RegisterGift)
    }
    
    func showLoginVC(){
        tabBarCoordinator?.showLoginView()
    }
    
    func showLockVC() {
        tabBarCoordinator?.showLockVC()
    }
    
    func showIntro() {
        tabBarCoordinator?.showLockVC()
    }
    
    func showSelectLanguageVC() {
        window = UIWindow(frame: UIScreen.main.bounds)
        let viewController = LanguageViewController()
        viewController.languageViewModel.tabBarIsInitialized = false
        window.rootViewController = viewController
        window.makeKeyAndVisible()
    }
    
    func showSelectCountryVC() {
        window = UIWindow(frame: UIScreen.main.bounds)
        let vc = SelectCountryVC()
        vc.vm.tabBarIsInitialized = false
        window.rootViewController = vc
        window.makeKeyAndVisible()
    }
    
    func shareApp() {
        tabBarCoordinator?.shareApp()
    }

    func refreshChat(id:Int) {
        tabBarCoordinator?.refreshChat(id:id)
    }
}
