//
//  HomeViewController.swift
//  app
//
//  Created by Hamed.Gh on 10/13/17.
//  Copyright © 2017 Hamed.Gh. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func deleteGift(giftId: String) {
        let mainURL: String = APIURLs.Gift

        APIRequest.Request(url: mainURL, token: "", httpMethod: .delete, complitionHandler: { (data, response, error) in
            
            APIRequest.logReply(data: data)
            
        })
    }
    
    func isUserPassCorrect(username:String, password:String) {
        let mainURL: String = APIURLs.BookmarkGift
        
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
    
    func submitAction(sender: AnyObject) {
        
        //declare parameter as a dictionary which contains string as key and value combination.
        let parameters = ["giftId": "hamed"] as [String: String]
        
        //create the url with NSURL
        let url = NSURL(string: "http://match.ulc.ir/api/v1.0/")
        
        //create the session object
        let session = URLSession.shared
        
        //now create the NSMutableRequest object using the url object
        let request = NSMutableURLRequest(url: url! as URL)
        request.httpMethod = "POST" //set http method as POST
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted) // pass dictionary to nsdata object and set it as request body
            
        } catch let error {
            print(error.localizedDescription)
        }
        
        //HTTP Headers
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        //create dataTask using the session object to send data to the server
        let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            
            guard error == nil else {
                return
            }
            
            guard let data = data else {
                return
            }
            
            do {
                //create json object from data
                if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: AnyObject] {
                    print(json)
                    // handle json...
                }
                
            } catch let error {
                print(error.localizedDescription)
            }
            
        })
        
        task.resume()
    }

}
