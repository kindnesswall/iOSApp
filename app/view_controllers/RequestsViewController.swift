//
//  RequestsViewController.swift
//  app
//
//  Created by Hamed.Gh on 12/13/17.
//  Copyright © 2017 Hamed.Gh. All rights reserved.
//

import UIKit

class RequestsViewController: UIViewController {

    @IBOutlet var requestView: UIView!
    @IBOutlet var loginView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        guard let _ = UserDefaults.standard.string(forKey: AppConstants.USER_TOKEN) else{
            loginView.isHidden = false
            requestView.isHidden = true
            return
        }
        
    }
    
    @IBAction func loginBtnClicked(_ sender: Any) {
        
        let controller=ActivationEnterPhoneViewController(nibName: "ActivationEnterPhoneViewController", bundle: Bundle(for: ActivationEnterPhoneViewController.self))
        //            controller.backgroundImage = image
        
        controller.setCloseComplition {
            
        }
        controller.setSubmitComplition { (str) in
            
        }
        
        let nc = UINavigationController.init(rootViewController: controller)
        self.tabBarController?.present(nc, animated: true, completion: nil)
        
    }
    
    
}
