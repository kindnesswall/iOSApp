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
    
    @IBOutlet weak var registeredGiftsTableView: UITableView!
    @IBOutlet weak var donatedGiftsTableView: UITableView!
    
    let registeredGiftsViewModel:RegisteredGiftViewModel = RegisteredGiftViewModel()
    let donatedGiftsViewModel:DonatedGiftViewModel = DonatedGiftViewModel()
    
    
    var registeredInitialLoadingIndicator:LoadingIndicator?
    var donatedInitialLoadingIndicator:LoadingIndicator?
    
    
    var registeredLazyLoadingIndicator:LoadingIndicator?
    var donatedLazyLoadingIndicator:LoadingIndicator?
    var tableViewCellHeight:CGFloat=122
    
    var registeredRefreshControl=UIRefreshControl()
    var donatedRefreshControl=UIRefreshControl()
    
    enum GiftType {
        case registered
        case donated
    }
    
//    var currentSegment :SegmentControlViewType = .registered
    
    deinit {
        print("MyGiftsViewController deinit")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.registeredGiftsViewModel.delegate = self
        self.donatedGiftsViewModel.delegate = self
        
        self.registeredGiftsTableView.hide()
        self.donatedGiftsTableView.hide()
        
        registeredGiftsTableView.register(type: GiftTableViewCell.self)
        donatedGiftsTableView.register(type: GiftTableViewCell.self)

        self.registeredInitialLoadingIndicator=LoadingIndicator(view: self.view)
        self.donatedInitialLoadingIndicator=LoadingIndicator(view: self.view)
        self.registeredLazyLoadingIndicator=LoadingIndicator(viewBelowTableView: self.view, cellHeight: tableViewCellHeight/2)
        self.donatedLazyLoadingIndicator=LoadingIndicator(viewBelowTableView: self.view, cellHeight: tableViewCellHeight/2)
        registeredGiftsTableView.contentInset=UIEdgeInsets(top: 0, left: 0, bottom: tableViewCellHeight/2, right: 0)
        donatedGiftsTableView.contentInset=UIEdgeInsets(top: 0, left: 0, bottom: tableViewCellHeight/2, right: 0)
        
        configRefreshControl()
        
        configSegmentControl()
        
        self.registeredGiftsViewModel.getGifts(index:0)
        self.donatedGiftsViewModel.getGifts(index:0)
    }
    
    func configRefreshControl(){
        self.registeredRefreshControl.addTarget(self, action: #selector(self.registeredRefreshControlAction), for: .valueChanged)
        registeredRefreshControl.tintColor=AppColor.tintColor
        self.registeredGiftsTableView.addSubview(registeredRefreshControl)
        
        self.donatedRefreshControl.addTarget(self, action: #selector(self.donatedRefreshControlAction), for: .valueChanged)
        donatedRefreshControl.tintColor=AppColor.tintColor
        self.donatedGiftsTableView.addSubview(donatedRefreshControl)
    }
    
    @objc func registeredRefreshControlAction(){
        self.registeredGiftsViewModel.reloadGifts()
        self.registeredInitialLoadingIndicator?.stopLoading()
    }
    
    @objc func donatedRefreshControlAction(){
        self.donatedGiftsViewModel.reloadGifts()
        self.donatedInitialLoadingIndicator?.stopLoading()
    }
    
    func setTableViewLazyLoading(isLoading:Bool,type:GiftType){
        
        var lazyLoadingIndicator:LoadingIndicator!
        
        switch type {
        case .registered:
            lazyLoadingIndicator=registeredLazyLoadingIndicator
        case .donated:
            lazyLoadingIndicator=donatedLazyLoadingIndicator
        }
        
        if isLoading {
            lazyLoadingIndicator?.startLoading()
        } else {
            lazyLoadingIndicator?.stopLoading()
        }
    }
    
    @IBAction func segmentControlAction(_ sender: Any) {
        hideOrShowCorrespondingViewOfSegmentControl()
    }
    
    
    enum SegmentControlViewType {
        case registered
        case donated
    }
    
    func hideOrShowCorrespondingViewOfSegmentControl(){
        switch self.segmentControl.selectedSegmentIndex {
        case 0:
            hideOrShowCorrespondingViewOfSegmentControl(type: .donated)
        case 1:
            hideOrShowCorrespondingViewOfSegmentControl(type: .registered)
        default:
            break
        }
    }
    
    func hideOrShowCorrespondingViewOfSegmentControl(type :SegmentControlViewType){
//        currentSegment = type
        
        if type == .registered {
            self.donatedGiftsTableView.hide()
            if self.registeredGiftsViewModel.gifts.count > 0{
                noGiftMsg.hide()
                registeredGiftsTableView.show()
                
            }else if registeredGiftsViewModel.isLoadingGifts {
                noGiftMsg.hide()
            }else{
                self.noGiftMsg.text = LocalizationSystem.getStr(forKey: LanguageKeys.noGiftRegistered)
                self.noGiftMsg.show()
            }
            
        }else if type == .donated{
            self.registeredGiftsTableView.hide()
            if self.donatedGiftsViewModel.gifts.count > 0{
                noGiftMsg.hide()
                donatedGiftsTableView.show()
                
            }else if donatedGiftsViewModel.isLoadingGifts{
                noGiftMsg.hide()
            }else{
                self.noGiftMsg.text = LocalizationSystem.getStr(forKey: LanguageKeys.noGiftDonated)
                self.noGiftMsg.show()
            }
        }
        
        //        if type == .registered, self.registeredGifts.count > 0{
        //            self.registeredGiftsTableView.show()
        //        } else {
        //            self.registeredGiftsTableView.hide()
        //        }
        //
        //        if type == .donated, self.donatedGifts.count > 0 {
        //            self.donatedGiftsTableView.show()
        //        } else {
        //            self.donatedGiftsTableView.hide()
        //        }
        
    }
    
    
    
    
    func showMessage() {
//        if self.currentSegment == .registered, self.registeredGifts.count <= 0{
//            self.noGiftMsg.text = LocalizationSystem.getStr(forKey: LanguageKeys.noGiftRegistered)
//            self.noGiftMsg.show()
//        } else if self.currentSegment == .donated, self.donatedGifts.count <= 0 {
//            self.noGiftMsg.text = LocalizationSystem.getStr(forKey: LanguageKeys.noGiftDonated)
//            self.noGiftMsg.show()
//        } else {
//            self.noGiftMsg.hide()
//        }
    }
    
    
    
    func configSegmentControl(){
        self.segmentControl.tintColor=AppColor.tintColor
        self.segmentControl.setTitleTextAttributes([NSAttributedString.Key.font:AppFont.getLightFont(size: 13)], for: .normal)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NavigationBarStyle.setDefaultStyle(navigationC: navigationController)
        self.setAllTextsInView()
    }
    
    func setAllTextsInView(){
        self.navigationItem.title = LocalizationSystem.getStr(forKey: LanguageKeys.MyGiftsViewController_title)
        
        self.segmentControl.setTitle(LocalizationSystem.getStr(forKey: LanguageKeys.donated), forSegmentAt: 0)
        self.segmentControl.setTitle(LocalizationSystem.getStr(forKey: LanguageKeys.registered), forSegmentAt: 1)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension MyGiftsViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let controller = GiftDetailViewController(
            nibName: GiftDetailViewController.identifier,
            bundle: GiftDetailViewController.bundle
        )
        
        switch tableView {
        case registeredGiftsTableView:
            controller.gift = registeredGiftsViewModel.gifts[indexPath.row]
        case donatedGiftsTableView:
            controller.gift = donatedGiftsViewModel.gifts[indexPath.row]
        default:
            break
        }
        
        controller.editHandler = { [weak self] in
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
        AppDelegate.me().reloadTabBarPages(currentPage: self)
    }
}
extension MyGiftsViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView {
        case registeredGiftsTableView:
            return registeredGiftsViewModel.gifts.count
        case donatedGiftsTableView:
            return donatedGiftsViewModel.gifts.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell=tableView.dequeueReusableCell(withIdentifier: GiftTableViewCell.identifier, for: indexPath) as! GiftTableViewCell
        
        switch tableView {
        case registeredGiftsTableView:
            
            cell.filViews(gift: registeredGiftsViewModel.gifts[indexPath.row])
            
            let index=indexPath.row+1
            if index==self.registeredGiftsViewModel.gifts.count {
                if !self.registeredGiftsViewModel.isLoadingGifts_ForLazyLoading {
                    registeredGiftsViewModel.getGifts(index: index)
                }
            }
            
            return cell
            
        case donatedGiftsTableView:
            
            cell.filViews(gift: donatedGiftsViewModel.gifts[indexPath.row])
            
            let index=indexPath.row+1
            if index==self.donatedGiftsViewModel.gifts.count {
                if !self.donatedGiftsViewModel.isLoadingGifts_ForLazyLoading {
                    donatedGiftsViewModel.getGifts(index: index)
                }
            }
            
            return cell
            
        default:
            fatalError()
        }
    }
    
    
}

extension MyGiftsViewController : ReloadablePage {
    func reloadPage(){
        self.registeredGiftsViewModel.reloadGifts()
        self.donatedGiftsViewModel.reloadGifts()
    }
}

extension MyGiftsViewController : GiftViewModelDelegate {
    func pageLoadingAnimation(viewModel: GiftViewModel, isLoading: Bool) {
        switch viewModel {
        case registeredGiftsViewModel:
            if isLoading {
                self.registeredInitialLoadingIndicator?.startLoading()
            } else {
                self.registeredInitialLoadingIndicator?.stopLoading()
            }
            
        case donatedGiftsViewModel:
            if isLoading {
                self.donatedInitialLoadingIndicator?.startLoading()
            } else {
                self.donatedInitialLoadingIndicator?.stopLoading()
            }
            
        default:
            break
        }
    }
    
    func lazyLoadingAnimation(viewModel: GiftViewModel, isLoading: Bool) {
        switch viewModel {
        case registeredGiftsViewModel:
            setTableViewLazyLoading(isLoading: isLoading, type: .registered)
            
        case donatedGiftsViewModel:
            setTableViewLazyLoading(isLoading: isLoading, type: .donated)
            
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
            
        default:
            break
        }
    }
    
    func showTableView(viewModel: GiftViewModel, show: Bool) {
        switch viewModel {
        case registeredGiftsViewModel:
            if show {
                self.registeredGiftsTableView.show()
            } else {
                self.registeredGiftsTableView.hide()
            }
        case donatedGiftsViewModel:
            if show {
                self.donatedGiftsTableView.show()
            } else {
                self.donatedGiftsTableView.hide()
            }
        default:
            break
        }
    }
    
    func reloadTableView(viewModel: GiftViewModel) {
        switch viewModel {
        case registeredGiftsViewModel:
            self.registeredGiftsTableView.reloadData()
        case donatedGiftsViewModel:
            self.donatedGiftsTableView.reloadData()
        default:
            break
        }
    }
    
    func insertNewItemsToTableView(viewModel: GiftViewModel, insertedIndexes: [IndexPath]) {
        
        self.hideOrShowCorrespondingViewOfSegmentControl()
        
        switch viewModel {
        case registeredGiftsViewModel:
            UIView.performWithoutAnimation {
                self.registeredGiftsTableView.insertRows(at: insertedIndexes, with: .bottom)
            }
        case donatedGiftsViewModel:
            UIView.performWithoutAnimation {
                self.donatedGiftsTableView.insertRows(at: insertedIndexes, with: .bottom)
            }
        default:
            break
        }
    }
    
    func presentfailedAlert(viewModel: GiftViewModel, alert: UIAlertController) {
        
    }
    
    
}
