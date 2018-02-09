//
//  MyKindnessWallViewController.swift
//  app
//
//  Created by Hamed.Gh on 12/14/17.
//  Copyright © 2017 Hamed.Gh. All rights reserved.
//

import UIKit

class MyKindnessWallViewController: UIViewController {

    @IBOutlet var loginLogoutBtn: UIButton!
    
    @IBAction func logoutBtnClicked(_ sender: Any) {
        
        if let _=UserDefaults.standard.string(forKey: AppConstants.Authorization) {
             AppDelegate.clearUserDefault()
        } else {
            AppDelegate.me().showLoginVC()
            
        }
       
        setLoginLogoutBtnTitle()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setLoginLogoutBtnTitle()
    }
    
    func setLoginLogoutBtnTitle(){
        if let _=UserDefaults.standard.string(forKey: AppConstants.Authorization) {
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
