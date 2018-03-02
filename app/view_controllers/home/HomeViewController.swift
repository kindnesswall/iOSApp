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
    
    let apiMethods=ApiMethods()
    
    var lazyLoadingCount=10
    var isLoadingGifts=false
    
    var categoryId="0"
    var categotyBtn:UIBarButtonItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationBar()
        
        tableview.dataSource = self
        tableview.delegate = self
        
        let bundle = Bundle(for: GiftTableViewCell.self)
        let nib = UINib(nibName: "GiftTableViewCell", bundle: bundle)
        self.tableview.register(nib, forCellReuseIdentifier: "GiftTableViewCell")
        
        getGifts(index:0)
        
    }
    
    func setNavigationBar(){
        categotyBtn=NavigationBarStyle.getNavigationItem(target: self, action: #selector(self.filterBtnClicked), text: "همه هدیه‌ها",font:AppFont.getRegularFont(size: 16))
        self.navigationItem.rightBarButtonItems=[categotyBtn!]
    }
    
    @objc func filterBtnClicked(){
        
        let controller=OptionsListViewController(nibName: "OptionsListViewController", bundle: Bundle(for:OptionsListViewController.self))
        controller.option = OptionsListViewController.Option.category
        controller.completionHandler={ [weak self] (id,name) in
            
            self?.categoryId=id ?? "0"
            self?.categotyBtn?.title=name
            self?.reloadPage()
    
        }
        let nc=UINavigationController(rootViewController: controller)
        self.present(nc, animated: true, completion: nil)
        
    }
    
    
    
    func reloadPage(){
        
        apiMethods.clearAllTasksAndSessions()
        isLoadingGifts=false
        getGifts(index:0)
    }
    
    func getGifts(index:Int){
        
        if isLoadingGifts {
            return
        }
        isLoadingGifts=true
        
        if index==0 {
            self.gifts=[]
            self.tableview.reloadData()
        }
        
        apiMethods.getGifts(cityId: "0", regionId: "0", categoryId: self.categoryId, startIndex: index,lastIndex: index+lazyLoadingCount, searchText: "") { (data) in
            APIRequest.logReply(data: data)
            
            if let reply=APIRequest.readJsonData(data: data, outputType: [Gift].self) {
                //                    if let status=reply.status,status==APIStatus.DONE {
                //                        print("\(reply.result?.token)")
                //                    }
                
                print("number of gifts: \(reply.count)")
                self.gifts.append(contentsOf: reply)
                
                if reply.count == self.lazyLoadingCount {
                    self.isLoadingGifts=false
                }
                
                self.tableview.reloadData()
            }
            
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NavigationBarStyle.setDefaultStyle(navigationC: navigationController)
        self.navigationItem.title="خانه"
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
        
        let index=indexPath.row+1
        if index==self.gifts.count {
            if !self.isLoadingGifts {
                getGifts(index: index)
            }
        }
        
        return cell
    }
}

extension HomeViewController:UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
     
        let controller = GiftDetailViewController(nibName: "GiftDetailViewController", bundle: Bundle(for: GiftDetailViewController.self))
        
        controller.gift = gifts[indexPath.row]
        print("Gift_id: \(controller.gift?.id ?? "")")
        
        self.navigationController?.pushViewController(controller, animated: true)
        
    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return CGFloat(122)
//    }
    
}
