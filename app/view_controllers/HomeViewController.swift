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
    var gifts:[Gift] = []
    @IBOutlet var tableview: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableview.dataSource = self
        tableview.delegate = self
        
        let bundle = Bundle(for: GiftTableViewCell.self)
        let nib = UINib(nibName: "GiftTableViewCell", bundle: bundle)
        self.tableview.register(nib, forCellReuseIdentifier: "GiftTableViewCell")
        
        ApiMethods.getGifts(cityId: "0", regionId: "0", categoryId: "4", startIndex: 0, searchText: "") { (data) in
            APIRequest.logReply(data: data)
            
            if let reply=APIRequest.readJsonData(data: data, outpuType: [Gift].self) {
//                    if let status=reply.status,status==APIStatus.DONE {
//                        print("\(reply.result?.token)")
//                    }
                
                print("number of gifts: \(reply.count)")
                self.gifts.append(contentsOf: reply)
                self.tableview.reloadData()
                }

        }
    }
    
}

extension HomeViewController:UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gifts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell=tableView.dequeueReusableCell(withIdentifier: "GiftTableViewCell") as! GiftTableViewCell
        
//        let gift:Gift = Gift()
//        gift.title = "هدیه"
//        gift.createDateTime = "تاریخ"
//        gift.description = "توضیحات بسیار کامل و جامع"
//        gift.giftImages = ["https://upload.wikimedia.org/wikipedia/commons/thumb/f/fa/Meso2mil-English.JPG/220px-Meso2mil-English.JPG"]
//

        cell.filViews(gift: gifts[indexPath.row])
        
        return cell
    }
}

extension HomeViewController:UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
     
        let controller = GiftDetailViewController(nibName: "GiftDetailViewController", bundle: Bundle(for: GiftDetailViewController.self))
        
        controller.gift = gifts[indexPath.row]
        
        self.navigationController?.pushViewController(controller, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(122)
    }
    
}
