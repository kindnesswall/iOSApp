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

    @IBOutlet weak var versionNoLbl: UILabel!
    
    @IBOutlet weak var bugReportBtn: UIButton!
    @IBOutlet weak var aboutKindnessWallBtn: UIButton!
    @IBOutlet weak var statisticBtn: UIButton!
    @IBOutlet weak var contactUsBtn: UIButton!
    @IBOutlet var loginLogoutBtn: UIButton!
    let keychain = KeychainSwift()
    
    @IBAction func shareApp(_ sender: Any) {
        AppDelegate.me().shareApp()
    }
    
    @IBAction func SwitchLanguageBtnClicked(_ sender: Any) {
        
        
        let controller = LanguageViewController()
        controller.languageViewModel.tabBarIsInitialized = true
        self.tabBarController?.present(controller, animated: true, completion: nil)

    }
    
    @IBAction func logoutBtnClicked(_ sender: Any) {
        
        if let _=keychain.get(AppConstants.Authorization) { //UserDefaults.standard.string(forKey: AppConstants.Authorization) {
            
            let alert = UIAlertController(
                title:LocalizationSystem.getStr(forKey: LanguageKeys.logout_dialog_title),
                message: LocalizationSystem.getStr(forKey: LanguageKeys.logout_dialog_text),
                preferredStyle: UIAlertController.Style.alert)
            
            alert.addAction(UIAlertAction(title: LocalizationSystem.getStr(forKey: LanguageKeys.ok), style: UIAlertAction.Style.default, handler: { (action) in
                AppDelegate.clearUserDefaultAuthValues()
                self.keychain.clear()
                UIApplication.shared.shortcutItems = []
                self.setLoginLogoutBtnTitle()
            }))
            
            alert.addAction(UIAlertAction(title: LocalizationSystem.getStr(forKey: LanguageKeys.cancel), style: UIAlertAction.Style.default, handler: { (action) in
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
        let urlAddress = APIURLs.telegramLink
        URLBrowser(urlAddress: urlAddress).openURL()
        
    }
    
    func setAllTextsInView(){
        setLoginLogoutBtnTitle()
        
        self.navigationItem.title=LocalizationSystem.getStr(forKey: LanguageKeys.myWall)
        
//        contactUsBtn.setTitle(AppLiteral.contactUs, for: .normal)
//        bugReportBtn.setTitle(AppLiteral.bugReport, for: .normal)
//        aboutKindnessWallBtn.setTitle(AppLiteral.aboutKindnessWall, for: .normal)
//        statisticBtn.setTitle(AppLiteral.statistic, for: .normal)
    }
    
    func setLoginLogoutBtnTitle(){
        if let _=keychain.get(AppConstants.Authorization) {
            loginLogoutBtn.setTitle(
                LocalizationSystem.getStr(forKey: LanguageKeys.logout) +
                    AppLanguage.getNumberString(number: (self.keychain.get(AppConstants.PHONE_NUMBER) ?? "")), for: .normal)
        } else {
            loginLogoutBtn.setTitle(LocalizationSystem.getStr(forKey: LanguageKeys.login), for: .normal)
        }
    }
    
    func getVersionBuildNo() -> String {
        let dic = Bundle.main.infoDictionary!
        let version = dic["CFBundleShortVersionString"] as! String
        let buildNumber = dic["CFBundleVersion"] as! String
        
        return version+"("+buildNumber+")"
    }
    
    deinit {
        print("MyKindnessWallViewController deinit")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        versionNoLbl.text = LocalizationSystem.getStr(forKey: LanguageKeys.AppVersion) + AppLanguage.getNumberString(number: getVersionBuildNo())
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NavigationBarStyle.setDefaultStyle(navigationC: navigationController)
        
        setAllTextsInView()
    }
}
