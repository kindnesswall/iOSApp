//
//  MyKindnessWallViewController.swift
//  app
//
//  Created by Hamed.Gh on 12/14/17.
//  Copyright © 2017 Hamed.Gh. All rights reserved.
//

import UIKit
import KeychainSwift

class MyKindnessWallViewController: UIViewController {

    @IBOutlet weak var bugReportBtn: UIButton!
    @IBOutlet weak var aboutKindnessWallBtn: UIButton!
    @IBOutlet weak var statisticBtn: UIButton!
    @IBOutlet weak var contactUsBtn: UIButton!
    @IBOutlet var loginLogoutBtn: UIButton!
    let keychain = KeychainSwift()
    
    @IBAction func SwitchLanguageBtnClicked(_ sender: Any) {
        
        let alert = UIAlertController(
            title:LocalizationSystem.getStr(forKey: "Switch_Language_dialog_title"),
                                      message: LocalizationSystem.getStr(forKey: "Switch_Language_dialog_text"),
                                      preferredStyle: UIAlertController.Style.alert)
        
            alert.addAction(UIAlertAction(title: LocalizationSystem.getStr(forKey: "Switch_Language_dialog_ok"), style: UIAlertAction.Style.default, handler: { (action) in
                if LocalizationSystem.sharedInstance.getLanguage() == "fa" {
                    LocalizationSystem.sharedInstance.setLanguage(languageCode: "en")
                    UIView.appearance().semanticContentAttribute = .forceLeftToRight
                } else {
                    LocalizationSystem.sharedInstance.setLanguage(languageCode: "fa")
                    UIView.appearance().semanticContentAttribute = .forceRightToLeft
                }
                
                exit(0)
            }))
        
        alert.addAction(UIAlertAction(title: LocalizationSystem.getStr(forKey: "Switch_Language_dialog_cancel"), style: UIAlertAction.Style.default, handler: { (action) in
            alert.dismiss(animated: true, completion: {
                
            })
        }))
        
        self.present(alert, animated: true, completion: nil)

    }
    
    @IBAction func logoutBtnClicked(_ sender: Any) {
        
        if let _=keychain.get(AppConstants.Authorization) { //UserDefaults.standard.string(forKey: AppConstants.Authorization) {
            
            
            let alert = UIAlertController(
                title:LocalizationSystem.getStr(forKey: "logout_dialog_title"),
                message: LocalizationSystem.getStr(forKey: "logout_dialog_text"),
                preferredStyle: UIAlertController.Style.alert)
            
            alert.addAction(UIAlertAction(title: LocalizationSystem.getStr(forKey: "logout_dialog_ok"), style: UIAlertAction.Style.default, handler: { (action) in
                AppDelegate.clearUserDefault()
                self.keychain.clear()
                self.setLoginLogoutBtnTitle()
            }))
            
            alert.addAction(UIAlertAction(title: LocalizationSystem.getStr(forKey: "logout_dialog_cancel"), style: UIAlertAction.Style.default, handler: { (action) in
                alert.dismiss(animated: true, completion: {
                    
                })
            }))
            
            self.present(alert, animated: true, completion: nil)

        } else {
            AppDelegate.me().showLoginVC()
            setLoginLogoutBtnTitle()
        }
        
    }
    
    @IBAction func contactUsBtnClicked(_ sender: Any) {
        
        let controller = ContactUsViewController()
        self.navigationController?.pushViewController(controller, animated: true)
        
    }
    @IBAction func statisticBtnAction(_ sender: Any) {
        let controller = StatisticViewController()
        self.navigationController?.pushViewController(controller, animated: true)
    }
    @IBAction func aboutKindnessWallBtnAction(_ sender: Any) {
        
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = mainStoryboard.instantiateViewController(withIdentifier: "IntroViewController") as! IntroViewController
        self.present(viewController, animated: true, completion: nil)
        
    }
    @IBAction func bugReportBtnAction(_ sender: Any) {
        guard let url = URL(string: "https://t.me/Kindness_Wall_Admin") else {
            return //be safe
        }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NavigationBarStyle.setDefaultStyle(navigationC: navigationController)
        
        setAllTextsInView()
    }
    
    func setAllTextsInView(){
        setLoginLogoutBtnTitle()
        
        self.navigationItem.title=AppLiteral.myWall
        
//        contactUsBtn.setTitle(AppLiteral.contactUs, for: .normal)
//        bugReportBtn.setTitle(AppLiteral.bugReport, for: .normal)
//        aboutKindnessWallBtn.setTitle(AppLiteral.aboutKindnessWall, for: .normal)
//        statisticBtn.setTitle(AppLiteral.statistic, for: .normal)
    }
    
    func setLoginLogoutBtnTitle(){
        if let _=keychain.get(AppConstants.Authorization) {
            loginLogoutBtn.setTitle(AppLiteral.logout, for: .normal)
        } else {
            loginLogoutBtn.setTitle(AppLiteral.login, for: .normal)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print("App Lang:")
        print(LocalizationSystem.sharedInstance.getLanguage())
        // Do any additional setup after loading the view.
    }
}
