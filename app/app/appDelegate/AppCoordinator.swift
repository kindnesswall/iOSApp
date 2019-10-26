//
//  AppCoordinator.swift
//  app
//
//  Created by Hamed Ghadirian on 22.10.19.
//  Copyright © 2019 Hamed.Gh. All rights reserved.
//

import Foundation
import UIKit

class AppCoordinator {
    var window: UIWindow
    var tabBarController = TabBarController()

    init(with window:UIWindow = UIWindow() ) {
        self.window = window
    }
    
    func showRootView() {
        window.makeKeyAndVisible()
        window.rootViewController = self.tabBarController
    }
    
    func showRegisterGiftTab() {
        self.tabBarController.tabBarController?.selectedIndex = AppConst.TabIndex.RegisterGift
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
        let text = "دیوار مهربانی، نیاز نداری بزار، نیاز داری بردار\n\n دانلود از سیب اپ:\nhttps://new.sibapp.com/applications/app-12\n\nدانلود از گوگل پلی:\nhttps://play.google.com/store/apps/details?id=ir.kindnesswall"
        
        // set up activity view controller
        let textToShare = [ text ]
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.window // so that iPads won't crash
        
        // exclude some activity types from the list (optional)
        activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook ]
        
        // present the view controller
        self.tabBarController.present(activityViewController, animated: true, completion: nil)
    }
    
    
}
