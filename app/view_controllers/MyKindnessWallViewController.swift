//
//  MyKindnessWallViewController.swift
//  app
//
//  Created by Hamed.Gh on 12/14/17.
//  Copyright © 2017 Hamed.Gh. All rights reserved.
//

import UIKit

class MyKindnessWallViewController: UIViewController {

    @IBOutlet var logoutBtn: UIButton!
    
    @IBAction func logoutBtnClicked(_ sender: Any) {

        AppDelegate.clearUserDefault()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
}
