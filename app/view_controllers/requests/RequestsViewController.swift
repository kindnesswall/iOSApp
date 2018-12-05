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
    
    deinit {
        print("RequestsViewController deinit")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableview.dataSource = self
        tableview.delegate = self
        
        requestView.hide()
        noRequestMsgLbl.hide()

        self.tableview.register(type: RequestsTableViewCell.self)
        loadingIndicator=LoadingIndicator(view: self.view)
        loadingIndicator.startLoading()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NavigationBarStyle.setDefaultStyle(navigationC: navigationController)
        self.navigationItem.title=LocalizationSystem.getStr(forKey: LanguageKeys.RequestsViewController_title)
        

        guard isFirstTime else{
            return
        }
        isFirstTime = false
        ApiMethods.getRequestsMyGifts(startIndex: 0) { [weak self] (data, response, error) in
            
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
                
                
                self?.loadingIndicator.stopLoading()
                
                self?.gifts.append(contentsOf: reply)
                self?.tableview.reloadData()
                
                self?.showViewsBasedOnNumberOfGifts()
                
                print("count:")
                print(reply.count)
                
            }
            
        }
    }
    
    func showViewsBasedOnNumberOfGifts() {
        if self.gifts.count <= 0 {
            self.noRequestMsgLbl.show()
            self.tableview.hide()
            self.requestView.hide()
        }else{
            self.noRequestMsgLbl.hide()
            self.tableview.show()
            self.requestView.show()
        }
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
        controller.onAccept = {
            self.gifts.remove(at: indexPath.row)
            
            self.tableview.deleteRows(at: [IndexPath(row: indexPath.row, section: 0)], with: .fade)
            self.tableview.reloadData()
            
            self.showViewsBasedOnNumberOfGifts()
        }
        controller.onReject = {
            if let requestCount = self.gifts[indexPath.row].requestCount, var count = Int(requestCount) {
                count = count - 1
                
                if count <= 0 {
                    self.showViewsBasedOnNumberOfGifts()
                }else{
                    self.gifts[indexPath.row].requestCount = String(count)
                
                    let indexPath = IndexPath(item: indexPath.row, section: 0)
                    self.tableview.reloadRows(at: [indexPath], with: .top)
                }
            }
        }

        self.navigationController?.pushViewController(controller, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(46)
    }
    
}

