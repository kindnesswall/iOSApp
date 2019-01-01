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

    
    let homeViewModel = HomeViewModel()
    
    let userDefault=UserDefaults.standard

    let NumberOfSecondsOfOneDay:Float = 26*60*60
    
    @IBOutlet var tableview: UITableView!
    
    
    
    let hud = JGProgressHUD(style: .dark)
    
    
    
    var lazyLoadingIndicator:LoadingIndicator?
    var tableViewCellHeight:CGFloat=122
    
    var refreshControl=UIRefreshControl()
    
    
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
        
        self.homeViewModel.delegate = self
        
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
        
        homeViewModel.getGifts(index:0)
    }
    
    func configRefreshControl(){
        self.refreshControl.addTarget(self, action: #selector(self.refreshControlAction), for: .valueChanged)
        refreshControl.tintColor=AppConst.Resource.Color.Tint
        self.tableview.addSubview(refreshControl)
    }
    @objc func refreshControlAction(){
        self.reloadPage()
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
        categotyBarBtn=UINavigationItem.getNavigationItem(target: self, action: #selector(self.categoryFilterBtnClicked), text: LocalizationSystem.getStr(forKey: LanguageKeys.allGifts),font:AppConst.Resource.Font.getRegularFont(size: 16))
        self.navigationItem.rightBarButtonItems=[categotyBarBtn!]
        
        cityBarBtn=UINavigationItem.getNavigationItem(target: self, action: #selector(self.cityFilterBtnClicked), text: LocalizationSystem.getStr(forKey: LanguageKeys.allCities),font:AppConst.Resource.Font.getRegularFont(size: 16))
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
            self?.homeViewModel.categoryId=id ?? "0"
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
            self?.homeViewModel.cityId=id ?? "0"
            self?.cityBarBtn?.title=name
            self?.reloadPage()
            
        }
        
        let nc=UINavigationController(rootViewController: controller)
        self.present(nc, animated: true, completion: nil)
        
    }
    
    
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        NavigationBarStyle.setDefaultStyle(navigationC: navigationController)
        self.setAllTextsInView()
    }
    
    func setAllTextsInView(){
        self.navigationItem.title=LocalizationSystem.getStr(forKey: LanguageKeys.home)
        if self.homeViewModel.categoryId=="0" {
            self.categotyBarBtn?.title=LocalizationSystem.getStr(forKey: LanguageKeys.allGifts)
        }
        if self.homeViewModel.cityId=="0" {
            self.cityBarBtn?.title=LocalizationSystem.getStr(forKey: LanguageKeys.allCities)
        }
    }
}

extension HomeViewController:UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.homeViewModel.gifts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let index=indexPath.row+1
        if index==self.homeViewModel.gifts.count {
            if !self.homeViewModel.isLoadingGifts {
                homeViewModel.getGifts(index: index)
            }
        }

        if let isAd = homeViewModel.gifts[indexPath.row].isAd, isAd {
            let cell=tableView.dequeueReusableCell(
                withIdentifier: GiftAdCell.identifier) as! GiftAdCell
        
            cell.setOnClickBtn {
                AppDelegate.me().shareApp()
            }
            
            cell.showAd()//index: index, vc: self)

            return cell
        }else{
            let cell=tableView.dequeueReusableCell(withIdentifier: GiftTableViewCell.identifier) as! GiftTableViewCell
            
            cell.filViews(gift: homeViewModel.gifts[indexPath.row])
            return cell
        }
        
    }
    
    func getGiftDetailVCFor(index:Int) -> UIViewController {
        let controller = GiftDetailViewController(
            nibName: GiftDetailViewController.identifier,
            bundle: GiftDetailViewController.bundle
        )
        
        controller.gift = homeViewModel.gifts[index]
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
            forKey: AppConst.UserDefaults.LastTimeISawAd)
    }
    
    func isMoreThanOneDayIDidntSawAd()->Bool {
        let lastTimeISawAd = userDefault.float(forKey: AppConst.UserDefaults.LastTimeISawAd)
        let currentDateTime = Float(Date().timeIntervalSinceReferenceDate)
        if currentDateTime > lastTimeISawAd + NumberOfSecondsOfOneDay {
            return true
        }else{
            return false
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if homeViewModel.gifts[indexPath.row].isAd == nil || homeViewModel.gifts[indexPath.row].isAd == false {
            if let ad = self.videoInterstitialAd, self.isMoreThanOneDayIDidntSawAd()
            {
                self.show(ad:ad)
                return
            }
        }
        
        guard !(homeViewModel.gifts[indexPath.row].isAd ?? false) else {
            return
        }
        
        let controller = getGiftDetailVCFor(index: indexPath.row)
        
        self.navigationController?.pushViewController(controller, animated: true)
        
    }
    
    func editHandler(){
        self.reloadPage()
        reloadOtherVCs()
    }
    func reloadOtherVCs(){
        AppDelegate.me().reloadTabBarPages(currentPage: self)
    }
    
}

extension HomeViewController:UIViewControllerPreviewingDelegate{
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        
        if let indexPath = tableview.indexPathForRow(at: location) {
            previewRowIndex = indexPath.row
            guard !(homeViewModel.gifts[indexPath.row].isAd ?? false) else {
                return nil
            }
            
            previewingContext.sourceRect = tableview.rectForRow(at: indexPath)
            return getGiftDetailVCFor(index: indexPath.row)
        }
        
        return nil
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        
        if let index = previewRowIndex, homeViewModel.gifts[index].isAd == nil || homeViewModel.gifts[index].isAd == false {
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

extension HomeViewController : ReloadablePage {
    func reloadPage(){
        self.homeViewModel.reloadPage()
    }
}

extension HomeViewController : HomeViewModelDelegate {
    
    
    func insertNewItemsToTableView(insertedIndexes:[IndexPath]) {
        //                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(1), execute: {
        UIView.performWithoutAnimation {
            self.tableview.insertRows(at: insertedIndexes, with: .bottom)
        }
        //                })
    }
    
    func reloadTableView() {
        self.tableview.reloadData()
    }
    
    func pageLoadingAnimation(isLoading:Bool) {
        if isLoading {
            hud.show(in: self.view)
        } else {
            self.hud.dismiss(afterDelay: 0)
        }
    }
    
    func lazyLoadingAnimation(isLoading:Bool) {
        self.setTableViewLazyLoading(isLoading: isLoading)
    }
    
    func refreshControlAnimation(isLoading:Bool) {
        if isLoading {
            
        } else {
            self.refreshControl.endRefreshing()
        }
    }
    
    func showTableView(show:Bool){
        if show {
            self.tableview.show()
        } else {
            self.tableview.hide()
        }
    }
    
    func presentfailedAlert(alert:UIAlertController) {
        self.present(alert, animated: true, completion: nil)
    }
    
    
}
