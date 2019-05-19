//
//  MyGiftsViewController.swift
//  app
//
//  Created by AmirHossein on 3/2/18.
//  Copyright © 2018 Hamed.Gh. All rights reserved.
//

import UIKit
import KeychainSwift

class MyGiftsViewController: UIViewController {

    @IBOutlet weak var noGiftMsg: UILabel!
    
    @IBOutlet weak var segmentControl: UISegmentedControl!
    
    @IBOutlet weak var donatedGiftsContainerView: UIView!
    @IBOutlet weak var registeredGiftsContainerView: UIView!
    @IBOutlet weak var receivedGiftsContainerView: UIView!
    
    @IBOutlet weak var registeredGiftsTableView: UITableView!
    @IBOutlet weak var donatedGiftsTableView: UITableView!
    @IBOutlet weak var receivedGiftsTableView: UITableView!
    
    let registeredGiftsViewModel = RegisteredGiftViewModel()
    let donatedGiftsViewModel = DonatedGiftViewModel()
    let receivedGiftsViewModel = ReceivedGiftViewModel()
    
    var registeredInitialLoadingIndicator:LoadingIndicator?
    var donatedInitialLoadingIndicator:LoadingIndicator?
    var receivedInitialLoadingIndicator:LoadingIndicator?
    
    var registeredLazyLoadingIndicator:LoadingIndicator?
    var donatedLazyLoadingIndicator:LoadingIndicator?
    var receivedLazyLoadingIndicator:LoadingIndicator?
    
    var tableViewCellHeight:CGFloat=122
    
    var registeredRefreshControl=UIRefreshControl()
    var donatedRefreshControl=UIRefreshControl()
    var receivedRefreshControl=UIRefreshControl()
    
    enum GiftType {
        case registered
        case donated
        case received
    }
    
    @IBAction func segmentControlAction(_ sender: Any) {
        updateUI()
    }
    
    func updateUI(){
        switch self.segmentControl.selectedSegmentIndex {
        case 0:
            hideOrShowCorrespondingViewOfSegmentControl(type: .donated)
        case 1:
            hideOrShowCorrespondingViewOfSegmentControl(type: .received)
        case 2:
            hideOrShowCorrespondingViewOfSegmentControl(type: .registered)
        default:
            break
        }
    }
    
    
    deinit {
        print("MyGiftsViewController deinit")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.registeredGiftsViewModel.delegate = self
        self.donatedGiftsViewModel.delegate = self
        self.receivedGiftsViewModel.delegate = self
        
        self.registeredGiftsTableView.dataSource = self.registeredGiftsViewModel
        self.donatedGiftsTableView.dataSource = self.donatedGiftsViewModel
        self.receivedGiftsTableView.dataSource = self.receivedGiftsViewModel
        
        configTableView(tableView: registeredGiftsTableView)
        configTableView(tableView: donatedGiftsTableView)
        configTableView(tableView: receivedGiftsTableView)
        
        
        configRefreshControl()
        configLoadingAnimations()
        configSegmentControl()
        
        self.updateUI()
        
        self.registeredGiftsViewModel.getGifts(beforeId: nil)
        self.donatedGiftsViewModel.getGifts(beforeId: nil)
        self.receivedGiftsViewModel.getGifts(beforeId: nil)
    }
    
    func configTableView(tableView:UITableView){
        tableView.register(type: GiftTableViewCell.self)
        tableView.contentInset=UIEdgeInsets(top: 0, left: 0, bottom: tableViewCellHeight/2, right: 0)
    }
    
    
    func configRefreshControl(){
        
        configRefreshControl(refreshControl: registeredRefreshControl, tableView: registeredGiftsTableView, action: #selector(self.registeredRefreshControlAction))
        
        configRefreshControl(refreshControl: donatedRefreshControl, tableView: donatedGiftsTableView, action: #selector(self.donatedRefreshControlAction))
        
        configRefreshControl(refreshControl: receivedRefreshControl, tableView: receivedGiftsTableView, action: #selector(self.receivedRefreshControlAction))
    }
    
    func configRefreshControl(refreshControl:UIRefreshControl,tableView:UITableView,action:Selector){
        refreshControl.addTarget(self, action: action, for: .valueChanged)
        refreshControl.tintColor=AppConst.Resource.Color.Tint
        tableView.addSubview(refreshControl)
    }
    
    func configLoadingAnimations(){
        self.registeredInitialLoadingIndicator=LoadingIndicator(view: self.registeredGiftsContainerView)
        self.donatedInitialLoadingIndicator=LoadingIndicator(view: self.donatedGiftsContainerView)
        self.receivedInitialLoadingIndicator=LoadingIndicator(view: self.receivedGiftsContainerView)
        
        self.registeredLazyLoadingIndicator=LoadingIndicator(viewBelowTableView: self.registeredGiftsContainerView, cellHeight: tableViewCellHeight/2)
        self.donatedLazyLoadingIndicator=LoadingIndicator(viewBelowTableView: self.donatedGiftsContainerView, cellHeight: tableViewCellHeight/2)
        self.receivedLazyLoadingIndicator=LoadingIndicator(viewBelowTableView: self.receivedGiftsContainerView, cellHeight: tableViewCellHeight/2)
    }
    
    func configSegmentControl(){
        self.segmentControl.tintColor=AppConst.Resource.Color.Tint
        self.segmentControl.setTitleTextAttributes([NSAttributedString.Key.font:AppConst.Resource.Font.getLightFont(size: 13)], for: .normal)
    }
    
    func getViewModel(type:GiftType)->GiftViewModel{
        let viewModel : GiftViewModel
        switch type {
        case .registered:
            viewModel = self.registeredGiftsViewModel
        case .donated:
            viewModel = self.donatedGiftsViewModel
        case .received:
            viewModel = self.receivedGiftsViewModel
        }
        return viewModel
    }
    
    func reloadViewModel(type:GiftType) {
        let viewModel = getViewModel(type: type)
        viewModel.reloadGifts()
    }
    
    @objc func registeredRefreshControlAction(){
        self.reloadViewModel(type: .registered)
        self.setTableViewLoading(isLoading: false, giftType: .registered, loadingType: .initial)
    }
    
    @objc func donatedRefreshControlAction(){
        self.reloadViewModel(type: .donated)
        self.setTableViewLoading(isLoading: false, giftType: .donated, loadingType: .initial)
    }
    
    @objc func receivedRefreshControlAction(){
        self.reloadViewModel(type: .received)
        self.setTableViewLoading(isLoading: false, giftType: .received, loadingType: .initial)
    }
    
    enum LoadingType {
        case initial
        case lazy
    }
    
    func setTableViewLoading(isLoading:Bool,giftType:GiftType,loadingType:LoadingType){
        
        let loadingIndicator:LoadingIndicator?
        
        switch giftType {
        case .registered:
            switch loadingType {
            case .initial:
                loadingIndicator=registeredInitialLoadingIndicator
            case .lazy:
                loadingIndicator=registeredLazyLoadingIndicator
            }
        case .donated:
            switch loadingType {
            case .initial:
                loadingIndicator=donatedInitialLoadingIndicator
            case .lazy:
                loadingIndicator=donatedLazyLoadingIndicator
            }
        case .received:
            switch loadingType {
            case .initial:
                loadingIndicator=receivedInitialLoadingIndicator
            case .lazy:
                loadingIndicator=receivedLazyLoadingIndicator
            }
        }
        
        if isLoading {
            loadingIndicator?.startLoading()
        } else {
            loadingIndicator?.stopLoading()
        }
    }
    
    func hideOrShowCorrespondingViewOfSegmentControl(type :GiftType){
        hideOrShowContainerView(type: type)
        hideOrShowNoGiftMsgLabel(type: type)
        
    }
    
    func hideOrShowContainerView(type :GiftType){
        if type == .registered {
            self.registeredGiftsContainerView.show()
        } else {
            self.registeredGiftsContainerView.hide()
        }
        if type == .donated {
            self.donatedGiftsContainerView.show()
        } else {
            self.donatedGiftsContainerView.hide()
        }
        if type == .received {
            self.receivedGiftsContainerView.show()
        } else {
            self.receivedGiftsContainerView.hide()
        }
    }
    
    func hideOrShowNoGiftMsgLabel(type: GiftType) {
        
        let viewModel = getViewModel(type: type)
        
        let count = viewModel.gifts.count
        let isLoading = viewModel.isLoadingGifts
        
        let show = (count == 0) && (!isLoading)
        hideOrShowNoGiftMsgLabel(show: show, type: type)
        
    }
    
    func hideOrShowNoGiftMsgLabel(show: Bool, type: GiftType) {
        let msg : String
        switch type {
        case .registered:
            msg = LocalizationSystem.getStr(forKey: LanguageKeys.noGiftRegistered)
        case .donated:
            msg = LocalizationSystem.getStr(forKey: LanguageKeys.noGiftDonated)
        case .received:
            msg = LocalizationSystem.getStr(forKey: LanguageKeys.noGiftReceived)
        }
        
        if show {
            self.noGiftMsg.text = msg
            self.noGiftMsg.show()
        } else {
            self.noGiftMsg.hide()
        }
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        NavigationBarStyle.setDefaultStyle(navigationC: navigationController)
        self.navigationItem.title = LocalizationSystem.getStr(forKey: LanguageKeys.MyGiftsViewController_title)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension MyGiftsViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let viewModel: GiftViewModel
        switch tableView {
        case registeredGiftsTableView:
            viewModel = self.registeredGiftsViewModel
        case donatedGiftsTableView:
            viewModel = self.donatedGiftsViewModel
        case receivedGiftsTableView:
            viewModel = self.receivedGiftsViewModel
        default:
            return
        }
        
        let controller = GiftDetailViewController()
        controller.gift = viewModel.gifts[indexPath.row]
        
        controller.editHandler = { [weak self] in
            self?.editHandler()
        }
        
        print("Gift_id: \(controller.gift?.id?.description ?? "")")
        
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func editHandler(){
        reloadPage()
        reloadOtherVCs()
    }
    
    
    func reloadOtherVCs(){
        AppDelegate.me().reloadTabBarPages(currentPage: self)
    }
}


extension MyGiftsViewController : ReloadablePage {
    func reloadPage(){
        self.reloadViewModel(type: .registered)
        self.reloadViewModel(type: .donated)
        self.reloadViewModel(type: .received)
    }
}

extension MyGiftsViewController : GiftViewModelDelegate {
    func pageLoadingAnimation(viewModel: GiftViewModel, isLoading: Bool) {
        switch viewModel {
        case registeredGiftsViewModel:
            setTableViewLoading(isLoading: isLoading, giftType: .registered, loadingType: .initial)
        case donatedGiftsViewModel:
            setTableViewLoading(isLoading: isLoading, giftType: .donated, loadingType: .initial)
        case receivedGiftsViewModel:
            setTableViewLoading(isLoading: isLoading, giftType: .received, loadingType: .initial)
            
        default:
            break
        }
    }
    
    func lazyLoadingAnimation(viewModel: GiftViewModel, isLoading: Bool) {
        switch viewModel {
        case registeredGiftsViewModel:
            setTableViewLoading(isLoading: isLoading, giftType: .registered, loadingType: .lazy)
            
        case donatedGiftsViewModel:
            setTableViewLoading(isLoading: isLoading, giftType: .donated, loadingType: .lazy)
            
        case receivedGiftsViewModel:
            setTableViewLoading(isLoading: isLoading, giftType: .received, loadingType: .lazy)
            
        default:
            break
        }
    }
    
    func refreshControlAnimation(viewModel: GiftViewModel, isLoading: Bool) {
        switch viewModel {
        case registeredGiftsViewModel:
            if isLoading {
            } else {
                self.registeredRefreshControl.endRefreshing()
            }
            
        case donatedGiftsViewModel:
            if isLoading {
            } else {
                self.donatedRefreshControl.endRefreshing()
            }
            
        case receivedGiftsViewModel:
            if isLoading {
            } else {
                self.receivedRefreshControl.endRefreshing()
            }
            
        default:
            break
        }
    }
    
    func getTableView(viewModel: GiftViewModel)->UITableView? {
        let tableView : UITableView?
        switch viewModel {
        case registeredGiftsViewModel:
            tableView = self.registeredGiftsTableView
        case donatedGiftsViewModel:
            tableView = self.donatedGiftsTableView
        case receivedGiftsViewModel:
            tableView = self.receivedGiftsTableView
        default:
            tableView = nil
        }
        return tableView
    }
    
    func showTableView(viewModel: GiftViewModel, show: Bool) {
        let tableView = getTableView(viewModel: viewModel)
        tableView?.isHidden = !show
    }
    
    func reloadTableView(viewModel: GiftViewModel) {
        
        // show or hide no gifts message
        self.updateUI()
        
        let tableView = getTableView(viewModel: viewModel)
        tableView?.reloadData()
    }
    
    func insertNewItemsToTableView(viewModel: GiftViewModel, insertedIndexes: [IndexPath]) {
        
        // show or hide no gifts message
        self.updateUI()
        
        let tableView = getTableView(viewModel: viewModel)
        UIView.performWithoutAnimation {
            tableView?.insertRows(at: insertedIndexes, with: .bottom)
        }
        
    }
    
    func presentfailedAlert(viewModel: GiftViewModel, alert: UIAlertController) {
        
    }
    
    
}
