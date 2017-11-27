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
    
    @IBOutlet var tableview: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableview.dataSource = self
        tableview.delegate = self
        
        let bundle = Bundle(for: GiftTableViewCell.self)
        let nib = UINib(nibName: "GiftTableViewCell", bundle: bundle)
        self.tableview.register(nib, forCellReuseIdentifier: "GiftTableViewCell")
    }
    
}

extension HomeViewController:UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell=tableView.dequeueReusableCell(withIdentifier: "GiftTableViewCell") as! GiftTableViewCell
        let gift:Gift = Gift()
        gift.title = "هدیه"
        gift.createDateTime = "تاریخ"
        gift.description = "توضیحات بسیار کامل و جامع"
        
        cell.filViews(gift: gift)
        
        return cell
    }
}

extension HomeViewController:UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return CGFloat(100)
//    }
    
    
}
