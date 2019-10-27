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
    var window: UIWindow? { get set }
}

class AppCoordinator:AppCoordinatorProtocol {
    var window: UIWindow?
    var tabBarCoordinator:TabBarCoordinator?
    
    func reloadTabBarPages(currentPage: ReloadablePage?){
        tabBarCoordinator?.reloadTabBarPages(currentPage: currentPage)
    }
    
    func refreshAppAfterSwitchUser() {
        tabBarCoordinator?.refreshAppAfterSwitchUser()
    }
    
    func showTabBar() {
        tabBarCoordinator = TabBarCoordinator(appCoordinator: self)
        setWindow(rootViewContrller: self.tabBarCoordinator?.tabBarController)
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
        tabBarCoordinator?.showIntro()
    }
    
    func showSelectLanguageVC() {
        let viewController = LanguageViewController()
        viewController.languageViewModel.tabBarIsInitialized = false
        setWindow(rootViewContrller: viewController)
    }
    
    func showSelectCountryVC() {
        let vc = SelectCountryVC()
        vc.vm.tabBarIsInitialized = false
        setWindow(rootViewContrller: vc)
    }
    
    func setWindow(rootViewContrller:UIViewController?) {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = rootViewContrller
        window?.makeKeyAndVisible()
    }
    
    func shareApp() {
        tabBarCoordinator?.shareApp()
    }

    func refreshChat(id:Int) {
        tabBarCoordinator?.refreshChat(id:id)
    }
}
