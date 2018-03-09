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
    var giftId:String = "-1"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableview.dataSource = self
        tableview.delegate = self
        
        self.tableview.register(type: RequestToAGiftTableViewCell.self)
        
        // Do any additional setup after loading the view.
        ApiMethods.getRecievedRequestList(giftId: giftId, startIndex: 0) { (data, response, error) in
            
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
            
            if let reply=APIRequest.readJsonData(data: data, outputType: [Request].self) {
                
                self.requests.append(contentsOf: reply)
                self.tableview.reloadData()
                
                print("count:")
                print(reply.count)
                
            }
        }
    }
    
    @IBAction func onCallClicked(_ sender: ButtonWithData) {
        print(sender.data)

        guard let clickedRequest = sender.data else{
            return
        }
        for (index, req) in requests.enumerated() {
            if req === clickedRequest {
                guard let phoneNumber = req.fromUser else {
                    return
                }
                guard let number = URL(string: "tel://" + phoneNumber) else { return }
                UIApplication.shared.open(number, options: [:], completionHandler: nil)
            }
        }
    }
    
    @IBAction func onMessageBtnClicked(_ sender: ButtonWithData) {
        print(sender.data)
        guard let clickedRequest = sender.data else{
            return
        }
        for (index, req) in requests.enumerated() {
            if req === clickedRequest {
                guard let phoneNumber = req.fromUser else {
                    return
                }
                
                UIApplication.shared.open(URL(string: "sms:" + phoneNumber)!, options: [:], completionHandler: nil)

            }
        }
    }
    
    
    @IBAction func onAcceptRequestClicked(_ sender: ButtonWithData) {
        print(sender.data)
        
        
        var controller:AddPopUpController?
        controller=AddPopUpController(nibName: "PromptUser", selfInstance: self, nibType: PromptUser.self, parentView: self.view, data: "آیا از قبول این درخواست مطمئن هستید؟", closeComplition: {}, submitComplition: {
            
            guard let clickedRequest = sender.data else{
                return
            }
            for (index, req) in self.requests.enumerated() {
                if req === clickedRequest {
                    FlashMessage.showMessage(body: "با درخواست موافقت شد",theme: .success)
                    self.navigationController?.popViewController(animated: true)
                    //        ApiMethods.acceptRequest(giftId: giftId, fromUserId: fromUserId) { (data) in
                    //
                    //        }
                }
            }
            
        }, canHide: true)
        
        controller?.showPopUp()
        
    }
    
    @IBAction func onRejectRequestBtnClicked(_ sender: ButtonWithData) {
        print(sender.data)
        
        var controller:AddPopUpController?
        controller=AddPopUpController(nibName: "PromptUser", selfInstance: self, nibType: PromptUser.self, parentView: self.view, data: "آیا از رد این درخواست مطمئن هستید؟", closeComplition: {}, submitComplition: {
            
            guard let clickedRequest = sender.data else{
                return
            }
            for (index, req) in self.requests.enumerated() {
                if req === clickedRequest {
                    
                    FlashMessage.showMessage(body: "درخواست رد شد",theme: .warning)
                    
                    self.requests.remove(at: index)
                    
                    self.tableview.deleteRows(at: [IndexPath(row: index, section: 0)], with: .fade)
                    self.tableview.reloadData()
                    //        ApiMethods.denyRequest(giftId: giftId, fromUserId: fromUserId) { (data) in
                    //
                    //        }
                }
            }
            
        }, canHide: true)
        
        controller?.showPopUp()
    }
    
}


extension RequestToAGiftViewController:UITableViewDataSource{
    
//    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
//        return true
//    }
//    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//            print("Deleted")
//            self.requests.remove(at: indexPath.row)
//            self.tableview.beginUpdates()
//            self.tableview.deleteRows(at: [indexPath], with: .automatic)
//            self.tableview.endUpdates()
//        }
//    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return requests.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell=tableView.dequeueReusableCell(withIdentifier: "RequestToAGiftTableViewCell") as! RequestToAGiftTableViewCell
        
//        cell.setRow(number: indexPath.row)
        cell.fillUI(request: requests[indexPath.row], rowNumber: indexPath.row)
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
