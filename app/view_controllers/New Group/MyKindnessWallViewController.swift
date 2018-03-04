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

    @IBOutlet weak var contactUsBtn: UIButton!
    @IBOutlet var loginLogoutBtn: UIButton!
    let keychain = KeychainSwift()
    
    @IBAction func logoutBtnClicked(_ sender: Any) {
        
        if let _=keychain.get(AppConstants.Authorization) { //UserDefaults.standard.string(forKey: AppConstants.Authorization) {
             AppDelegate.clearUserDefault()
            keychain.clear()
        } else {
            AppDelegate.me().showLoginVC()
        }
       
        setLoginLogoutBtnTitle()
        
    }
    
    @IBAction func contactUsBtnClicked(_ sender: Any) {
        guard let url = URL(string: "https://t.me/Kindness_Wall_Admin") else {
            return //be safe
        }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NavigationBarStyle.setDefaultStyle(navigationC: navigationController)
        self.navigationItem.title="دیوار من"
        
        setLoginLogoutBtnTitle()
    }
    
    func setLoginLogoutBtnTitle(){
        if let _=keychain.get(AppConstants.Authorization) {
            loginLogoutBtn.setTitle("خروج", for: .normal)
        } else {
            loginLogoutBtn.setTitle("ورود", for: .normal)
            
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
}
