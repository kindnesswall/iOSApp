//
//  RequestsViewController.swift
//  app
//
//  Created by Hamed.Gh on 12/13/17.
//  Copyright © 2017 Hamed.Gh. All rights reserved.
//

import UIKit

class RequestsViewController: UIViewController {

    @IBOutlet var loginView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func loginBtnClicked(_ sender: Any) {
        
        let controller=ActivationEnterPhoneViewController(nibName: "ActivationEnterPhoneViewController", bundle: Bundle(for: ActivationEnterPhoneViewController.self))
        //            controller.backgroundImage = image
        let nc = UINavigationController.init(rootViewController: controller)
        self.tabBarController?.present(nc, animated: true, completion: nil)
        
    }
    
    
}
