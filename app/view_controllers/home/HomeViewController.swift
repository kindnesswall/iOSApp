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

    let vm = HomeVM()
    
    let userDefault=UserDefaults.standard

    let NumberOfSecondsOfOneDay:Float = 26*60*60
    
    let hud = JGProgressHUD(style: .dark)
    
    var lazyLoadingIndicator:LoadingIndicator?
    var tableViewCellHeight:CGFloat=122
    
    var refreshControl=UIRefreshControl()
    
    var categotyBarBtn:UIBarButtonItem?
    var cityBarBtn:UIBarButtonItem?
    
    var previewRowIndex:Int?
    var videoInterstitialAd:TapsellAd?
    var rewardBasedAd:TapsellAd?
    
    @IBOutlet var tableview: UITableView!
    
    deinit {
        print("HomeViewController deinit")
    }
    
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
        
        self.vm.delegate = self
        
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
        
        self.tableview.register(type: GiftTableViewCell.self)
        self.tableview.register(type: GiftAdCell.self)
        
        vm.getGifts(index:0)
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
        
        let controller=OptionsListViewController()
        
        controller.option = OptionsListViewController.Option.category
        controller.hasDefaultOption=true
        controller.completionHandler={ [weak self] (id,name) in
            
            print("Selected Category id: \(id ?? "")")
            self?.vm.categoryId=id ?? "0"
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
            self?.vm.cityId=id ?? "0"
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
        if self.vm.categoryId=="0" {
            self.categotyBarBtn?.title=LocalizationSystem.getStr(forKey: LanguageKeys.allGifts)
        }
        if self.vm.cityId=="0" {
            self.cityBarBtn?.title=LocalizationSystem.getStr(forKey: LanguageKeys.allCities)
        }
    }
}

extension HomeViewController : ReloadablePage {
    func reloadPage(){
        self.vm.reloadPage()
    }
}

