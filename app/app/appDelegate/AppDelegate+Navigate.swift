//
//  AppDelegate+Navigate.swift
//  app
//
//  Created by Hamed Ghadirian on 22.10.19.
//  Copyright © 2019 Hamed.Gh. All rights reserved.
//

import Foundation
import UIKit

extension AppDelegate{
    
    func shareApp() {
        let text = "دیوار مهربانی، نیاز نداری بزار، نیاز داری بردار\n\n دانلود از سیب اپ:\nhttps://new.sibapp.com/applications/app-12\n\nدانلود از گوگل پلی:\nhttps://play.google.com/store/apps/details?id=ir.kindnesswall"
        
        // set up activity view controller
        let textToShare = [ text ]
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.window // so that iPads won't crash
        
        // exclude some activity types from the list (optional)
        activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook ]
        
        // present the view controller
        self.tabBarController.tabBarController?.present(activityViewController, animated: true, completion: nil)
    }
    
    func showLockVC() {
        let controller = LockViewController()
        controller.mode = .CheckPassCode
        controller.isCancelable = false
        self.tabBarController.tabBarController?.present(controller, animated: true, completion: nil)
    }
    
    func showTabbarIntro() {
        
        initializeTabbar()
        
        if !uDStandard.bool(forKey: AppConst.UserDefaults.WATCHED_INTRO) {
            showIntro()
            uDStandard.set(true, forKey: AppConst.UserDefaults.WATCHED_INTRO)
            uDStandard.synchronize()
        }
    }
    
    func showSelectLanguageVC() {
        window = UIWindow(frame: UIScreen.main.bounds)
        let viewController = LanguageViewController()
        viewController.languageViewModel.tabBarIsInitialized = false
        //        let nc = UINavigationController.init(rootViewController: viewController)
        window!.rootViewController = viewController
        window!.makeKeyAndVisible()
    }
    
    func showSelectCountryVC() {
        window = UIWindow(frame: UIScreen.main.bounds)
        let vc = SelectCountryVC()
        vc.vm.tabBarIsInitialized = false
        //        let nc = UINavigationController.init(rootViewController: viewController)
        window!.rootViewController = vc
        window!.makeKeyAndVisible()
    }
    
    
    func showIntro() {
        
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = mainStoryboard.instantiateViewController(withIdentifier: IntroViewController.identifier) as! IntroViewController
        self.tabBarController.tabBarController?.present(viewController, animated: true, completion: nil)
        
    }
}
