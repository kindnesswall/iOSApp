//
//  HomeViewController.swift
//  app
//
//  Created by Hamed.Gh on 10/13/17.
//  Copyright © 2017 Hamed.Gh. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    var gifts:[Gift] = []
    @IBOutlet var tableview: UITableView!
    
    let apiMethods=ApiMethods()
    
    var initialLoadingIndicator:LoadingIndicator?
    var lazyLoadingCount=20
    var isLoadingGifts=false
    var lazyLoadingIndicator:LoadingIndicator?
    var tableViewCellHeight:CGFloat=122
    
    var refreshControl=UIRefreshControl()
    
    var categoryId="0"
    var cityId="0"
    var categotyBarBtn:UIBarButtonItem?
    var cityBarBtn:UIBarButtonItem?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initialLoadingIndicator=LoadingIndicator(view: self.tableview)
        self.lazyLoadingIndicator=LoadingIndicator(viewBelowTableView: self.view, cellHeight: tableViewCellHeight)
        
        configRefreshControl()
        
        setNavigationBar()
        
        tableview.dataSource = self
        tableview.delegate = self
        
        let bundle = Bundle(for: GiftTableViewCell.self)
        let nib = UINib(nibName: "GiftTableViewCell", bundle: bundle)
        self.tableview.register(nib, forCellReuseIdentifier: "GiftTableViewCell")
        
        getGifts(index:0)
        
    }
    
    func configRefreshControl(){
        self.refreshControl.addTarget(self, action: #selector(self.refreshControlAction), for: .valueChanged)
        refreshControl.tintColor=AppColor.tintColor
        self.tableview.addSubview(refreshControl)
    }
    @objc func refreshControlAction(){
        reloadPage()
        self.initialLoadingIndicator?.stopLoading()
    }
    
    func setTableViewLazyLoading(isLoading:Bool){
        if isLoading {
            self.tableview.contentInset=UIEdgeInsets(top: 0, left: 0, bottom: tableViewCellHeight, right: 0)
            self.lazyLoadingIndicator?.startLoading()
        } else {
            self.tableview.contentInset=UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            self.lazyLoadingIndicator?.stopLoading()
        }
    }
    
    func setNavigationBar(){
        categotyBarBtn=UINavigationItem.getNavigationItem(target: self, action: #selector(self.categoryFilterBtnClicked), text: "همه هدیه‌ها",font:AppFont.getRegularFont(size: 16))
        self.navigationItem.rightBarButtonItems=[categotyBarBtn!]
        
        cityBarBtn=UINavigationItem.getNavigationItem(target: self, action: #selector(self.cityFilterBtnClicked), text: "همه شهر‌ها",font:AppFont.getRegularFont(size: 16))
        self.navigationItem.leftBarButtonItems=[cityBarBtn!]
    }
    
    @objc func categoryFilterBtnClicked(){
        
        let controller=OptionsListViewController(nibName: "OptionsListViewController", bundle: Bundle(for:OptionsListViewController.self))
        controller.option = OptionsListViewController.Option.category
        controller.hasDefaultOption=true
        controller.completionHandler={ [weak self] (id,name) in
            
            print("Selected Category id: \(id ?? "")")
            self?.categoryId=id ?? "0"
            self?.categotyBarBtn?.title=name
            self?.reloadPage()
    
        }
        let nc=UINavigationController(rootViewController: controller)
        self.present(nc, animated: true, completion: nil)
        
    }
    
    @objc func cityFilterBtnClicked(){
        
        let controller=OptionsListViewController()
        controller.option = OptionsListViewController.Option.city(showRegion: false)
        controller.hasDefaultOption=true
        controller.completionHandler={ [weak self] (id,name) in
            
            print("Selected City id: \(id ?? "")")
            self?.cityId=id ?? "0"
            self?.cityBarBtn?.title=name
            self?.reloadPage()
            
        }
        let nc=UINavigationController(rootViewController: controller)
        self.present(nc, animated: true, completion: nil)
        
    }
    
    
    var initialGiftsLoadingHasOccurred=false
    func reloadPage(){
        if initialGiftsLoadingHasOccurred {
            apiMethods.clearAllTasksAndSessions()
            isLoadingGifts=false
            getGifts(index:0)
        }
    }
    
    func getGifts(index:Int){
        
        self.initialGiftsLoadingHasOccurred=true
        
        if isLoadingGifts {
            return
        }
        isLoadingGifts=true
        
        if index==0 {
            self.gifts=[]
            self.tableview.reloadData()
            self.initialLoadingIndicator?.startLoading()
        } else {
            self.setTableViewLazyLoading(isLoading: true)
        }
        
        apiMethods.getGifts(cityId: self.cityId, regionId: "0", categoryId: self.categoryId, startIndex: index,lastIndex: index+lazyLoadingCount, searchText: "") { (data) in
            APIRequest.logReply(data: data)
            
            if let reply=APIRequest.readJsonData(data: data, outputType: [Gift].self) {
                self.refreshControl.endRefreshing()
                self.initialLoadingIndicator?.stopLoading()
                
                if reply.count == self.lazyLoadingCount {
                    self.isLoadingGifts=false
                } else {
                    self.setTableViewLazyLoading(isLoading: false)
                }
                
                var insertedIndexes=[IndexPath]()
                for i in self.gifts.count..<self.gifts.count+reply.count {
                    insertedIndexes.append(IndexPath(item: i, section: 0))
                }
                
                self.gifts.append(contentsOf: reply)
                
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(1), execute: {
                    UIView.performWithoutAnimation {
                        self.tableview.insertRows(at: insertedIndexes, with: .bottom)
                    }
                })
                
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
        controller.editHandler={ [weak self] in
            self?.editHandler()
        }
        print("Gift_id: \(controller.gift?.id ?? "")")
        
        self.navigationController?.pushViewController(controller, animated: true)
        
    }
    
    func editHandler(){
        reloadPage()
        reloadOtherVCs()
    }
    func reloadOtherVCs(){
        if let myGiftsVC=((self.tabBarController?.viewControllers?[TabIndex.MyGifts] as? UINavigationController)?.viewControllers.first) as? MyGiftsViewController {
            myGiftsVC.reloadPage()
        }
    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return CGFloat(122)
//    }
    
}
