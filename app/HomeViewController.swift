//
//  HomeViewController.swift
//  app
//
//  Created by Hamed.Gh on 10/13/17.
//  Copyright © 2017 Hamed.Gh. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    let userDefault = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        ApiMethods.login(username: "09353703108", password: "") { (data) in
//            APIRequest.logReply(data: data)
//        }
        
//        ApiMethods.register(telephone: "09353703108") { (data) in
//            APIRequest.logReply(data: data)
//        }
        
    }
    
    func isUserPassCorrect(username:String, password:String) {
        let mainURL: String = APIURLs.bookmark
        
        var jsonDicInput : [String : Any] = ApiInput.isUserPassCorrectInput(username: username, password: password, registeration_id: "", device_id: "")
        
        APIRequest.request(url: mainURL, token: nil, inputJson: jsonDicInput) { (data, response, error) in
            
            APIRequest.logReply(data: data)
            
//            if let reply=APIRequest.readJsonData(data: data, outpuType: ResponseModel<UserAccount>.self) {
//                if let status=reply.status,status==APIStatus.DONE {
//                    print("\(reply.result?.token)")
//                }
//            }
        }
    }
    
}
