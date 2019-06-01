//
//  HomeViewController.swift
//  app
//
//  Created by Hamed.Gh on 10/13/17.
//  Copyright © 2017 Hamed.Gh. All rights reserved.
//

import UIKit
import JGProgressHUD
import Firebase

class HomeViewController: UIViewController {

    let vm = HomeVM()
    
    let userDefault=UserDefaults.standard

    let NumberOfSecondsOfOneDay:Float = 26*60*60
    
    let hud = JGProgressHUD(style: .dark)
    
    var lazyLoadingIndicator:LoadingIndicator?
    var tableViewCellHeight:CGFloat=122
    
    var refreshControl=UIRefreshControl()
    
    var categotyBarBtn:UIBarButtonItem?
    var provinceBarBtn:UIBarButtonItem?
    
    var previewRowIndex:Int?

    @IBOutlet var tableview: UITableView!
    
    deinit {
        print("HomeViewController deinit")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.vm.delegate = self
        
        registerForPreviewing(with: self, sourceView: tableview)
        
        self.tableview.hide()
        
        hud.textLabel.text = LocalizationSystem.getStr(forKey: LanguageKeys.loading)
        
        self.lazyLoadingIndicator=LoadingIndicator(viewBelowTableView: self.view, cellHeight: tableViewCellHeight/2)
        self.tableview.contentInset=UIEdgeInsets(top: 0, left: 0, bottom: tableViewCellHeight/2, right: 0)
        
        configRefreshControl()
        
        setNavigationBar()
        
        tableview.dataSource = vm
        tableview.delegate = self
        
        self.tableview.register(type: GiftTableViewCell.self)
        
        vm.getGifts(beforeId:nil)

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
        
        provinceBarBtn=UINavigationItem.getNavigationItem(target: self, action: #selector(self.cityFilterBtnClicked), text: LocalizationSystem.getStr(forKey: LanguageKeys.allProvinces),font:AppConst.Resource.Font.getRegularFont(size: 16))
        self.navigationItem.leftBarButtonItems=[provinceBarBtn!]
    }
    
    @objc func categoryFilterBtnClicked(){
        
        let controller=OptionsListViewController()
        let viewModel = CategoryListVM(hasDefaultOption: true)
        controller.viewModel=viewModel
        controller.completionHandler={ [weak self] (id,name) in
            
            print("Selected Category id: \(id?.description ?? "")")
            self?.vm.categoryId=id
            self?.categotyBarBtn?.title=name
            self?.reloadPage()
    
        }
        let nc=UINavigationController(rootViewController: controller)
        self.present(nc, animated: true, completion: nil)
        
    }
    
    @objc func cityFilterBtnClicked(){
        
        let controller=OptionsListViewController()
        let viewModel = PlaceListViewModel(placeType:.province, showCities: false, hasDefaultOption: true)
        controller.viewModel=viewModel
        controller.completionHandler={ [weak self] (id,name) in
            
            print("Selected province id: \(id?.description ?? "")")
            self?.vm.provinceId=id
            self?.provinceBarBtn?.title=name
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
        if self.vm.categoryId==nil {
            self.categotyBarBtn?.title=LocalizationSystem.getStr(forKey: LanguageKeys.allGifts)
        }
        if self.vm.provinceId==nil {
            self.provinceBarBtn?.title=LocalizationSystem.getStr(forKey: LanguageKeys.allProvinces)
        }
    }
    
    func getGiftDetailVCFor(index:Int) -> UIViewController {
        let controller = GiftDetailViewController()
        
        controller.gift = vm.gifts[index]
        controller.editHandler={ [weak self] in
            self?.editHandler()
        }
        print("Gift_id: \(controller.gift?.id?.description ?? "")")
        
        return controller
    }
}

extension HomeViewController : ReloadablePage {
    func reloadPage(){
        self.vm.reloadPage()
    }
}

