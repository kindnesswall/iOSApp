//
//  HomeViewController.swift
//  app
//
//  Created by Hamed.Gh on 10/13/17.
//  Copyright © 2017 Hamed.Gh. All rights reserved.
//

import UIKit
import JGProgressHUD
import TapsellSDKv3

class HomeViewController: UIViewController {

//    var nativeBanner : TSNativeBannerAdView!
//    var nativeBannerBundle:TSNativeBannerBundle?

    let userDefault=UserDefaults.standard

    let NumberOfSecondsOfOneDay:Float = 26*60*60
    var gifts:[Gift] = []
    @IBOutlet var tableview: UITableView!
    
    let apiMethods=ApiMethods()
    
    let hud = JGProgressHUD(style: .dark)
    
    var lazyLoadingCount=20
    var isLoadingGifts=false
    var lazyLoadingIndicator:LoadingIndicator?
    var tableViewCellHeight:CGFloat=122
    
    var refreshControl=UIRefreshControl()
    
    var categoryId="0"
    var cityId="0"
    var categotyBarBtn:UIBarButtonItem?
    var cityBarBtn:UIBarButtonItem?
    
    var previewRowIndex:Int?
    
    deinit {
        print("HomeViewController deinit")
    }
    
    var videoInterstitialAd:TapsellAd?
    var rewardBasedAd:TapsellAd?
    
    func requestRewardBasedAd() {
        let requestOptions = TSAdRequestOptions()
        requestOptions.setCacheType(CacheTypeCached)
        
        Tapsell.requestAd(
            forZone: TapSellConstants.ZoneID.RewardBased,
            andOptions: requestOptions,
            onAdAvailable:{ [weak self](tapsellAd) in
                print("\n\n onAdAvailable \n\n")
                
                self?.rewardBasedAd = tapsellAd
                
            }, onNoAdAvailable: {
                print("onNoAdAvailable")
        }, onError: { (error) in
            print("onError")
        }, onExpiring: { (ad) in
            print("onExpiring")
        }
        )
    }
    
    func requestVideoInterstitialAd() {
        let requestOptions = TSAdRequestOptions()
        requestOptions.setCacheType(CacheTypeCached)
        
        Tapsell.requestAd(
            forZone: TapSellConstants.ZoneID.VideoInterstitial,
            andOptions: requestOptions,
            onAdAvailable:{ [weak self](tapsellAd) in
                print("\n\n onAdAvailable \n\n")
                
                self?.videoInterstitialAd = tapsellAd
                
            }, onNoAdAvailable: {
                print("onNoAdAvailable")
            }, onError: { (error) in
                print("onError")
            }, onExpiring: { (ad) in
                print("onExpiring")
            }
        )
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerForPreviewing(with: self, sourceView: tableview)
        
        Tapsell.initialize(withAppKey: TapSellConstants.KEY)
        
        self.requestVideoInterstitialAd()
//        self.requestRewardBasedAd()
        
        self.tableview.hide()
        
        hud.textLabel.text = LocalizationSystem.getStr(forKey: LanguageKeys.loading)
        
        self.lazyLoadingIndicator=LoadingIndicator(viewBelowTableView: self.view, cellHeight: tableViewCellHeight/2)
        self.tableview.contentInset=UIEdgeInsets(top: 0, left: 0, bottom: tableViewCellHeight/2, right: 0)
        
        configRefreshControl()
        
        setNavigationBar()
        
        tableview.dataSource = self
        tableview.delegate = self
        
        self.tableview.register(
            GiftTableViewCell.nib,
            forCellReuseIdentifier: GiftTableViewCell.identifier
        )
        self.tableview.register(
            GiftAdCell.nib,
            forCellReuseIdentifier: GiftAdCell.identifier
        )
        
        getGifts(index:0)
    }
    
    func configRefreshControl(){
        self.refreshControl.addTarget(self, action: #selector(self.refreshControlAction), for: .valueChanged)
        refreshControl.tintColor=AppColor.tintColor
        self.tableview.addSubview(refreshControl)
    }
    @objc func refreshControlAction(){
        reloadPage()
        self.hud.dismiss(afterDelay: 0)
    }
    
    func setTableViewLazyLoading(isLoading:Bool){
        if isLoading {
            self.lazyLoadingIndicator?.startLoading()
        } else {
            self.lazyLoadingIndicator?.stopLoading()
        }
    }
    
    func setNavigationBar(){
        categotyBarBtn=UINavigationItem.getNavigationItem(target: self, action: #selector(self.categoryFilterBtnClicked), text: LocalizationSystem.getStr(forKey: LanguageKeys.allGifts),font:AppFont.getRegularFont(size: 16))
        self.navigationItem.rightBarButtonItems=[categotyBarBtn!]
        
        cityBarBtn=UINavigationItem.getNavigationItem(target: self, action: #selector(self.cityFilterBtnClicked), text: LocalizationSystem.getStr(forKey: LanguageKeys.allCities),font:AppFont.getRegularFont(size: 16))
        self.navigationItem.leftBarButtonItems=[cityBarBtn!]
    }
    
    @objc func categoryFilterBtnClicked(){
        
        let controller=OptionsListViewController(
            nibName: OptionsListViewController.identifier,
            bundle: OptionsListViewController.bundle
        )
        
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
            hud.show(in: self.view)
            
        } else {
            self.setTableViewLazyLoading(isLoading: true)
        }
        
        apiMethods.getGifts(cityId: self.cityId, regionId: "0", categoryId: self.categoryId, startIndex: index,lastIndex: index+lazyLoadingCount, searchText: "") { [weak self] (data, response, error) in
//            APIRequest.logReply(data: data)
            
            guard error == nil, let response = response as? HTTPURLResponse, response.statusCode>=200,response.statusCode<300 else {
                print("Get error register")
                
                self?.refreshControl.endRefreshing()
                self?.hud.dismiss(afterDelay: 0)
                self?.setTableViewLazyLoading(isLoading: false)
                
                let alert = UIAlertController(
                    title:LocalizationSystem.getStr(forKey: LanguageKeys.requestfail_dialog_title),
                    message: LocalizationSystem.getStr(forKey: LanguageKeys.requestfail_dialog_text),
                    preferredStyle: UIAlertController.Style.alert)
                
                alert.addAction(UIAlertAction(title: LocalizationSystem.getStr(forKey: LanguageKeys.ok), style: UIAlertAction.Style.default, handler: { (action) in
                    self?.isLoadingGifts=false
                    self?.getGifts(index:index)
                }))
                
                if let gifts = self?.gifts, gifts.count > 0 {
                    self?.tableview.show()
                    alert.addAction(UIAlertAction(title: LocalizationSystem.getStr(forKey: LanguageKeys.cancel), style: UIAlertAction.Style.default, handler: { (action) in
                        alert.dismiss(animated: true, completion: {
                            
                        })
                    }))
                }else{
                    self?.tableview.hide()
                }
                
                self?.present(alert, animated: true, completion: nil)
                
                return
            }
            
            if let reply=APIRequest.readJsonData(data: data, outputType: [Gift].self) {
                
                if index==0 {
                    self?.gifts=[]
                    self?.tableview.show()
                    self?.tableview.reloadData()
                }
                
                self?.refreshControl.endRefreshing()
                
                self?.hud.dismiss(afterDelay: 0)
                
                self?.setTableViewLazyLoading(isLoading: false)
                
                if reply.count == self?.lazyLoadingCount {
                    self?.isLoadingGifts=false
                }
                
                var insertedIndexes=[IndexPath]()
                let firstIndex = self?.gifts.count
                
                let chunkedGifts = reply.chunked(into: 10)
                for chunk in chunkedGifts {
                    let ad = Gift()
                    ad.isAd = true
                    self?.gifts.append(ad)
                    self?.gifts.append(contentsOf: chunk)
                }
                if let firstIndex = firstIndex, let lastIndex = self?.gifts.count {
                    for i in firstIndex..<lastIndex{
                        insertedIndexes.append(IndexPath(item: i, section: 0))
                    }
                }
//                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(1), execute: {
                UIView.performWithoutAnimation {
                    self?.tableview.insertRows(at: insertedIndexes, with: .bottom)
                }
//                })
                
            }
            
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NavigationBarStyle.setDefaultStyle(navigationC: navigationController)
        self.setAllTextsInView()
    }
    
    func setAllTextsInView(){
        self.navigationItem.title=LocalizationSystem.getStr(forKey: LanguageKeys.home)
        if categoryId=="0" {
            self.categotyBarBtn?.title=LocalizationSystem.getStr(forKey: LanguageKeys.allGifts)
        }
        if cityId=="0" {
            self.cityBarBtn?.title=LocalizationSystem.getStr(forKey: LanguageKeys.allCities)
        }
    }
    
}

extension HomeViewController:UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gifts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let index=indexPath.row+1
        if index==self.gifts.count {
            if !self.isLoadingGifts {
                getGifts(index: index)
            }
        }

        if let isAd = gifts[indexPath.row].isAd, isAd {
            let cell=tableView.dequeueReusableCell(
                withIdentifier: GiftAdCell.identifier) as! GiftAdCell
        
            cell.showAd()//index: index, vc: self)

            return cell
        }else{
            let cell=tableView.dequeueReusableCell(withIdentifier: GiftTableViewCell.identifier) as! GiftTableViewCell
            
            cell.filViews(gift: gifts[indexPath.row])
            return cell
        }
        
    }
    
    func getGiftDetailVCFor(index:Int) -> UIViewController {
        let controller = GiftDetailViewController(
            nibName: GiftDetailViewController.identifier,
            bundle: GiftDetailViewController.bundle
        )
        
        controller.gift = gifts[index]
        controller.editHandler={ [weak self] in
            self?.editHandler()
        }
        print("Gift_id: \(controller.gift?.id ?? "")")
        
        return controller
    }
}

extension HomeViewController:UITableViewDelegate {
    
    func show(ad:TapsellAd) {
        let showOptions = TSAdShowOptions()
        showOptions.setOrientation(OrientationUnlocked)
        showOptions.setBackDisabled(false)
        showOptions.setShowDialoge(false)
        
        Tapsell.setAdShowFinishedCallback { [weak self](ad, completed) in
            if(ad!.isRewardedAd() && completed){
                // give reward to user if neccessary
                
            }
        }
        
        ad.show(
            with: showOptions,
            andOpenedCallback:{ [weak self](tapsellAd) in
                print("\n\n andOpenedCallback \n\n")
                
            }, andClosedCallback:{ (tapsellAd) in
                print("\n\n andClosedCallback \n\n")
            }
        )
        self.userDefault.set(
            Float(Date().timeIntervalSinceReferenceDate),
            forKey: AppConstants.LastTimeISawAd)
    }
    
    func isMoreThanOneDayIDidntSawAd()->Bool {
        let lastTimeISawAd = userDefault.float(forKey: AppConstants.LastTimeISawAd)
        let currentDateTime = Float(Date().timeIntervalSinceReferenceDate)
        if currentDateTime > lastTimeISawAd + NumberOfSecondsOfOneDay {
            return true
        }else{
            return false
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if gifts[indexPath.row].isAd == nil || gifts[indexPath.row].isAd == false {
            if let ad = self.videoInterstitialAd, self.isMoreThanOneDayIDidntSawAd()
            {
                self.show(ad:ad)
                return
            }
        }
        
        guard !(gifts[indexPath.row].isAd ?? false) else {
            return
        }
        
        let controller = getGiftDetailVCFor(index: indexPath.row)
        
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
    
}

extension HomeViewController:UIViewControllerPreviewingDelegate{
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        
        if let indexPath = tableview.indexPathForRow(at: location) {
            previewRowIndex = indexPath.row
            guard !(gifts[indexPath.row].isAd ?? false) else {
                return nil
            }
            
            previewingContext.sourceRect = tableview.rectForRow(at: indexPath)
            return getGiftDetailVCFor(index: indexPath.row)
        }
        
        return nil
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        
        if let index = previewRowIndex, gifts[index].isAd == nil || gifts[index].isAd == false {
            previewRowIndex = nil
            if let ad = self.videoInterstitialAd, self.isMoreThanOneDayIDidntSawAd()
            {
                self.show(ad:ad)
                return
            }
        }
        self.navigationController?.pushViewController(viewControllerToCommit, animated: true)
    }
}
