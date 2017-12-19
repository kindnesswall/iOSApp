//
//  RequestToAGiftViewController.swift
//  app
//
//  Created by Hamed.Gh on 12/15/17.
//  Copyright © 2017 Hamed.Gh. All rights reserved.
//

import UIKit

class RequestToAGiftViewController: UIViewController {

    let userDefault = UserDefaults.standard
    var requests:[Request] = []
    @IBOutlet var tableview: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        ApiMethods.getRecievedRequestList(giftId: "", startIndex: 0) { (data, response, error) in
            
            APIRequest.logReply(data: data)
            if let response = response as? HTTPURLResponse {
                if response.statusCode < 200 && response.statusCode >= 300 {
                    return
                }
            }
            guard error == nil else {
                print("Get error register")
                return
            }
            
            if let reply=APIRequest.readJsonData(data: data, outpuType: [Request].self) {
                
                self.requests.append(contentsOf: reply)
                self.tableview.reloadData()
                
                print("count:")
                print(reply.count)
                
            }
        }
    }
    
    @IBAction func onCallClicked(_ sender: ButtonWithData) {
        
    }
    
    @IBAction func onMessageBtnClicked(_ sender: ButtonWithData) {
        
    }
    
    @IBAction func onAcceptRequestClicked(_ sender: ButtonWithData) {
        
        
    }
    
    @IBAction func onRejectRequestBtnClicked(_ sender: ButtonWithData) {
        
        
    }
    
}


extension RequestToAGiftViewController:UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return requests.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell=tableView.dequeueReusableCell(withIdentifier: "GiftTableViewCell") as! GiftTableViewCell
        
        //        let gift:Gift = Gift()
        //        gift.title = "هدیه"
        //        gift.createDateTime = "تاریخ"
        //        gift.description = "توضیحات بسیار کامل و جامع"
        //        gift.giftImages = ["https://upload.wikimedia.org/wikipedia/commons/thumb/f/fa/Meso2mil-English.JPG/220px-Meso2mil-English.JPG"]
        //
        
//        cell.filViews(gift: gifts[indexPath.row])
        
        return cell
    }
}

extension RequestToAGiftViewController:UITableViewDelegate {
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        
//        let controller = GiftDetailViewController(nibName: "GiftDetailViewController", bundle: Bundle(for: GiftDetailViewController.self))
//        
//        controller.gift = gifts[indexPath.row]
//        
//        self.navigationController?.pushViewController(controller, animated: true)
//        
//    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(122)
    }
    
}
