//
//  RequestsViewController.swift
//  app
//
//  Created by Hamed.Gh on 12/13/17.
//  Copyright © 2017 Hamed.Gh. All rights reserved.
//

import UIKit
import KeychainSwift

class RequestsViewController: UIViewController {

    let userDefault = UserDefaults.standard
    var gifts:[Gift] = []
    var isFirstTime = true
    var loadingIndicator:LoadingIndicator!
    let keychain = KeychainSwift()

    @IBOutlet weak var noRequestMsgLbl: UILabel!
    @IBOutlet var tableview: UITableView!
    
    @IBOutlet var requestView: UIView!
    @IBOutlet var loginView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()

        tableview.dataSource = self
        tableview.delegate = self
        
        loginView.hide()
        requestView.hide()
        noRequestMsgLbl.hide()

        self.tableview.register(type: RequestsTableViewCell.self)
        loadingIndicator=LoadingIndicator(view: self.view)
        loadingIndicator.startLoading()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NavigationBarStyle.setDefaultStyle(navigationC: navigationController)
        self.navigationItem.title=LocalizationSystem.getStr(forKey: LanguageKeys.RequestsViewController_title)
        
        guard let _ = keychain.get(AppConstants.Authorization) else{
            loginView.show()
            requestView.hide()
            loadingIndicator.stopLoading()
            return
        }

        guard isFirstTime else{
            return
        }
        isFirstTime = false
        ApiMethods.getRequestsMyGifts(startIndex: 0) { (data, response, error) in
            
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
            
            if let reply=APIRequest.readJsonData(data: data, outputType: [Gift].self) {
                
                self.loginView.hide()
                
                self.loadingIndicator.stopLoading()
                
                self.gifts.append(contentsOf: reply)
                self.tableview.reloadData()
                if self.gifts.count <= 0 {
                    self.noRequestMsgLbl.show()
                    self.tableview.hide()
                    self.requestView.hide()
                }else{
                    self.noRequestMsgLbl.hide()
                    self.tableview.show()
                    self.requestView.show()
                }
                
                print("count:")
                print(reply.count)
                
            }
            
        }
    }
    
    @IBAction func loginBtnClicked(_ sender: Any) {
        
        let controller=ActivationEnterPhoneViewController(nibName: "ActivationEnterPhoneViewController", bundle: Bundle(for: ActivationEnterPhoneViewController.self))
        //            controller.backgroundImage = image
        
        controller.setCloseComplition {
            
        }
        controller.setSubmitComplition { (str) in
            self.loginView.hide()
            self.requestView.show()
        }
        
        let nc = UINavigationController.init(rootViewController: controller)
        self.tabBarController?.present(nc, animated: true, completion: nil)
        
    }
    
    
}

extension RequestsViewController:UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gifts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell=tableView.dequeueReusableCell(withIdentifier: "RequestsTableViewCell") as! RequestsTableViewCell
        
        //        let gift:Gift = Gift()
        //        gift.title = "هدیه"
        //        gift.createDateTime = "تاریخ"
        //        gift.description = "توضیحات بسیار کامل و جامع"
        //        gift.giftImages = ["https://upload.wikimedia.org/wikipedia/commons/thumb/f/fa/Meso2mil-English.JPG/220px-Meso2mil-English.JPG"]
        //
        
        cell.fillUI(gift: gifts[indexPath.row])
        
        return cell
    }
}

extension RequestsViewController:UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let controller = RequestToAGiftViewController(nibName: "RequestToAGiftViewController", bundle: Bundle(for: RequestToAGiftViewController.self))
        
        controller.giftId = gifts[indexPath.row].id!
        
        self.navigationController?.pushViewController(controller, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(46)
    }
    
}

