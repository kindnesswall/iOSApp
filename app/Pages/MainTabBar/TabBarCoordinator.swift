//
//  TabBarCoordinator.swift
//  app
//
//  Created by Hamed Ghadirian on 26.10.19.
//  Copyright © 2019 Hamed.Gh. All rights reserved.
//

import Foundation
import UIKit

class TabBarCoordinator : TabCoordinator{
    lazy var tabBarController = TabBarController(tabBarCoordinator:self)
    var appCoordinator: AppCoordinatorProtocol
    
    let home = HomeCoordinator()
//    let charities = CharitiesCoordinator()
    let donateGiftCoordinator = DonateGiftCoordinator()
    
    var moreCoordinator = MoreCoordinator()
    var chatCoordinator = ChatCoordinator()
    var myWallCoordinator = MyWallCoordinator()
    
    var tabBarPagesRelaodDelegates = [ReloadablePage]()
    init(appCoordinator: AppCoordinatorProtocol) {
        self.appCoordinator = appCoordinator
        initializeTabs()
    }
    
    func setSelectedTab(index:Int) {
        tabBarController.selectedIndex = index
    }
    
    func checkForLogin()->Bool{
        if AppDelegate.me().appViewModel.isUserLogedIn() {
            return true
        }
        showLoginView()
        return false
    }
    
    func showLoginView() {
        let controller=LoginRegisterViewController()
        let nc = UINavigationController.init(rootViewController: controller)
        self.tabBarController.present(nc, animated: true, completion: nil)
    }
    
    func showLockVC() {
        let controller = LockViewController()
        controller.modalPresentationStyle = .fullScreen
        controller.mode = .CheckPassCode
        controller.isCancelable = false
        self.tabBarController.present(controller, animated: true, completion: nil)
    }
    
    func showIntro() {
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = mainStoryboard.instantiateViewController(withIdentifier: IntroViewController.identifier) as! IntroViewController
        self.tabBarController.present(viewController, animated: true, completion: nil)
    }
    
    func shareApp() {
        let text = "دیوار مهربانی، نیاز نداری بزار، نیاز داری بردار\n\n دانلود از سیب اپ:\nhttps://new.sibapp.com/applications/app-12\n\nدانلود از گوگل پلی:\nhttps://play.google.com/store/apps/details?id=ir.kindnesswall"
        
        // set up activity view controller
        let textToShare = [ text ]
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.appCoordinator.window // so that iPads won't crash
        
        // exclude some activity types from the list (optional)
        activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook ]
        
        // present the view controller
        self.tabBarController.present(activityViewController, animated: true, completion: nil)
    }
    
    func initializeTabs()  {
        var tabs = [UIViewController](repeating: UIViewController(), count: 5)
        home.showHome()
        tabs[AppConst.TabIndex.HOME] = home.navigationController
        
        myWallCoordinator.showMyWall()
        tabs[AppConst.TabIndex.MyWall] = myWallCoordinator.navigationController//charities.navigationController
        tabs[AppConst.TabIndex.RegisterGift] = donateGiftCoordinator.navigationController
        
        chatCoordinator.showRoot()
        tabs[AppConst.TabIndex.Chat] = chatCoordinator.navigationController
        
        moreCoordinator.showMore()
        tabs[AppConst.TabIndex.More] = moreCoordinator.navigationController
        
        tabBarController = TabBarController(tabBarCoordinator:self)
        self.tabBarController.viewControllers = tabs
        
        setTabsDelegates()

        self.tabBarController.tabBarController?.selectedIndex = AppConst.TabIndex.HOME
    }
    
    func refreshAppAfterSwitchUser(){
        chatCoordinator = ChatCoordinator()
        chatCoordinator.showRoot()
        let chatNC = chatCoordinator.navigationController
        _ = chatNC.view
        self.tabBarController.viewControllers?[AppConst.TabIndex.Chat] = chatNC
        
        moreCoordinator = MoreCoordinator()
        moreCoordinator.showMore()
        let moreNC = moreCoordinator.navigationController
        _ = moreNC.view
        self.tabBarController.viewControllers?[AppConst.TabIndex.More] = moreNC
        
        myWallCoordinator = MyWallCoordinator()
        myWallCoordinator.showMyWall()
        let myWallNC = myWallCoordinator.navigationController
        _ = myWallNC.view
        self.tabBarController.viewControllers?[AppConst.TabIndex.MyWall] = myWallNC
    }

    func setTabsDelegates(){
        guard let tabs = self.tabBarController.viewControllers as? [UINavigationController] else { return }

        self.tabBarPagesRelaodDelegates = []

        for tab in tabs {
            guard let reloadPageDelegate = tab.viewControllers.first as? ReloadablePage else {
                continue
            }

            if
                tab.viewControllers.first as? HomeViewController != nil
                    ||
                    tab.viewControllers.first as? MyWallViewController != nil {

                self.tabBarPagesRelaodDelegates.append(reloadPageDelegate)
            }
        }
    }

    func reloadTabBarPages(currentPage: ReloadablePage?){
        for delegate in self.tabBarPagesRelaodDelegates {
            if let currentPage=currentPage, delegate === currentPage {
                continue
            }
            delegate.reloadPage()
        }
    }
    
    func refreshChat(id:Int) {
        chatCoordinator.refreshChatProtocol?.fetchChat(chatId:id)
    }
}
