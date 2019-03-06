//
//  RequestToAGiftViewController.swift
//  app
//
//  Created by Hamed.Gh on 12/15/17.
//  Copyright © 2017 Hamed.Gh. All rights reserved.
//

import UIKit
import JGProgressHUD

class RequestToAGiftViewController: UIViewController {

    let userDefault = UserDefaults.standard
    var requests:[Request] = []
    @IBOutlet var tableview: UITableView!
    var giftId:Int = -1
    
    let hud = JGProgressHUD(style: .dark)
    
    var onReject:(()->())?
    var onAccept:(()->())?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableview.dataSource = self
        tableview.delegate = self
        
        hud.textLabel.text = ""//LocalizationSystem.getStr(forKey: LanguageKeys.loading)

        self.tableview.register(type: RequestToAGiftTableViewCell.self)
        
        // Do any additional setup after loading the view.
//        ApiMethods.getRecievedRequestList(giftId: giftId, startIndex: 0) { [weak self] (data, response, error) in
//            
//            ApiUtility.watch(data: data)
//            if let response = response as? HTTPURLResponse {
//                if response.statusCode < 200 && response.statusCode >= 300 {
//                    return
//                }
//            }
//            guard error == nil else {
//                print("Get error register")
//                return
//            }
//            
//            if let reply=ApiUtility.convert(data: data, to: [Request].self) {
//                
//                self?.requests.append(contentsOf: reply)
//                self?.tableview.reloadData()
//                
//                print("count:")
//                print(reply.count)
//                
//            }
//        }
    }
    
    @IBAction func onCallClicked(_ sender: ButtonWithData) {
        print(sender.data?.description ?? "")

        guard let clickedRequest = sender.data else{
            return
        }
        for (_, req) in requests.enumerated() {
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
        print(sender.data?.description ?? "")
        guard let clickedRequest = sender.data else{
            return
        }
        for (_, req) in requests.enumerated() {
            if req === clickedRequest {
                guard let phoneNumber = req.fromUser else {
                    return
                }
                
                UIApplication.shared.open(URL(string: "sms:" + phoneNumber)!, options: [:], completionHandler: nil)

            }
        }
    }
    
    
    @IBAction func onAcceptRequestClicked(_ sender: ButtonWithData) {
        print(sender.data?.description ?? "")
        
        PopUpMessage.showPopUp(
            nibClass: PromptUser.self,
            data: LocalizationSystem.getStr(forKey: LanguageKeys.popup_accept_request_msg),
            animation: .none,declineHandler: nil) { (_) in
            
            guard let clickedRequest = sender.data else{
                return
            }
                
            for (index, req) in self.requests.enumerated() {
                if req === clickedRequest {
                    
                    self.hud.show(in: self.view)
                    if let fromUserID = self.requests[index].fromUserId,
                        let giftId = self.requests[index].giftId{
                        ApiMethods.acceptRequest(
                            giftId: giftId,
                            fromUserId: fromUserID
                        ) { [weak self] (data) in
                            
                            self?.hud.dismiss(afterDelay: 0)
                            
                            FlashMessage.showMessage(
                                body:LocalizationSystem.getStr(forKey: LanguageKeys.popup_request_accepted),
                                theme: .success
                            )
                            self?.onAccept?()
                            
                            self?.navigationController?.popViewController(animated: true)
                        }
                    }
                    
                }
            }
        }
        
        
    }
    
    @IBAction func onRejectRequestBtnClicked(_ sender: ButtonWithData) {
        print(sender.data?.description ?? "")
        
        PopUpMessage.showPopUp(
            nibClass: PromptUser.self,
            data: LocalizationSystem.getStr(forKey: LanguageKeys.popup_reject_request_msg),
            animation: .none,
            declineHandler: nil) { (_) in
            
            guard let clickedRequest = sender.data else{
                return
            }
            for (index, req) in self.requests.enumerated() {
                if req === clickedRequest {
                    
                    if let fromUserID = self.requests[index].fromUserId,
                        let giftId = self.requests[index].giftId{
                        
                        self.hud.show(in: self.view)
                        
                        ApiMethods.denyRequest(
                            giftId: giftId,
                            fromUserId: fromUserID) { [weak self] (data) in
                            
                                self?.hud.dismiss(afterDelay: 0)
                                
                                FlashMessage.showMessage(
                                body:LocalizationSystem.getStr(forKey: LanguageKeys.popup_request_rejected)
                                ,theme: .warning)
                            
                                self?.requests.remove(at: index)
                            
                                self?.tableview.deleteRows(at: [IndexPath(row: index, section: 0)], with: .fade)
                                self?.tableview.reloadData()
                                
                                self?.onReject?()
                        }
                    }
                }
            }
        }
        
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
