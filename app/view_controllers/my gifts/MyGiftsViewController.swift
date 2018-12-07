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
    
    let myGiftViewModel:MyGiftViewModel = MyGiftViewModel()
    
    var registeredGifts=[Gift]()
    var donatedGifts=[Gift]()
    
    var registeredInitialLoadingIndicator:LoadingIndicator?
    var donatedInitialLoadingIndicator:LoadingIndicator?
    var lazyLoadingCount=20
    var isLoadingRegisteredGifts_ForLazyLoading=false
    var isLoadingDonatedGifts_ForLazyLoading=false
    
    var isLoadingRegisteredGifts=false
    var isLoadingDonatedGifts=false
    
    var registeredLazyLoadingIndicator:LoadingIndicator?
    var donatedLazyLoadingIndicator:LoadingIndicator?
    var tableViewCellHeight:CGFloat=122
    
    var registeredRefreshControl=UIRefreshControl()
    var donatedRefreshControl=UIRefreshControl()
    
    enum GiftType {
        case registered
        case donated
    }
    
    var currentSegment :SegmentControlViewType = .registered
    
    deinit {
        print("MyGiftsViewController deinit")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        getRegisteredGifts(index:0)
        getDonatedGifts(index:0)
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
        self.reloadRegisteredGifts()
        self.registeredInitialLoadingIndicator?.stopLoading()
    }
    
    @objc func donatedRefreshControlAction(){
        self.reloadDonatedGifts()
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
        currentSegment = type
        
        if type == .registered {
            self.donatedGiftsTableView.hide()
            if self.registeredGifts.count > 0{
                noGiftMsg.hide()
                registeredGiftsTableView.show()

            }else if isLoadingRegisteredGifts {
                noGiftMsg.hide()
            }else{
                self.noGiftMsg.text = LocalizationSystem.getStr(forKey: LanguageKeys.noGiftRegistered)
                self.noGiftMsg.show()
            }

        }else if type == .donated{
            self.registeredGiftsTableView.hide()
            if self.donatedGifts.count > 0{
                noGiftMsg.hide()
                donatedGiftsTableView.show()

            }else if isLoadingDonatedGifts{
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
    
    enum SegmentControlViewType {
        case registered
        case donated
    }
    
    var initialRegisteredGiftsLoadingHasOccurred=false
    func reloadRegisteredGifts(){
        
        if self.initialRegisteredGiftsLoadingHasOccurred {
            APICall.stopAndClearRequests(sessions: &registeredGiftsSessions, tasks: &registeredGiftsTasks)
            isLoadingRegisteredGifts_ForLazyLoading=false
            getRegisteredGifts(index: 0)
        }
        
    }
    
    var registeredGiftsSessions:[URLSession?]=[]
    var registeredGiftsTasks:[URLSessionDataTask?]=[]
    
    func getRegisteredGifts(index:Int){
        
        self.initialRegisteredGiftsLoadingHasOccurred=true
        
        if isLoadingRegisteredGifts_ForLazyLoading {
            return
        }
        isLoadingRegisteredGifts_ForLazyLoading=true
        
        if index==0 {
            self.registeredInitialLoadingIndicator?.startLoading()
        } else {
            setTableViewLazyLoading(isLoading: true, type: .registered)
        }
        
        guard let userId=KeychainSwift().get(AppConstants.USER_ID) else {
            return
        }
        let url=APIURLs.getMyRegisteredGifts+"/"+userId+"/\(index)/\(index+lazyLoadingCount)"
        
        let input:APIEmptyInput?=nil
        
        isLoadingRegisteredGifts = true
        APICall.request(url: url, httpMethod: .GET, input: input , sessions: &registeredGiftsSessions, tasks: &registeredGiftsTasks) { [weak self] (data, response, error) in
            
            self?.isLoadingRegisteredGifts = false
            
            if let reply=APIRequest.readJsonData(data: data, outputType: [Gift].self) {
                
                if index==0 {
                    self?.registeredGifts=[]
                    self?.registeredGiftsTableView.reloadData()
                }
                
                self?.registeredRefreshControl.endRefreshing()
                self?.registeredInitialLoadingIndicator?.stopLoading()
                self?.setTableViewLazyLoading(isLoading: false, type: .registered)

                
                if reply.count == self?.lazyLoadingCount {
                    self?.isLoadingRegisteredGifts_ForLazyLoading=false
                }
                
                var insertedIndexes=[IndexPath]()
                if let minCount = self?.registeredGifts.count {
                    for i in minCount..<minCount+reply.count {
                        insertedIndexes.append(IndexPath(item: i, section: 0))
                    }
                }
                
                self?.registeredGifts.append(contentsOf: reply)
                self?.hideOrShowCorrespondingViewOfSegmentControl(type: self?.currentSegment ?? .registered)
                
//                self?.showMessage()
//                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(1), execute: {
                    UIView.performWithoutAnimation {
                        self?.registeredGiftsTableView.insertRows(at: insertedIndexes, with: .bottom)
                    }
//                })
                
            }
        }
        
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
    
    var initialDonatedGiftsLoadingHasOccurred=false
    func reloadDonatedGifts(){
        
        if self.initialDonatedGiftsLoadingHasOccurred {
            APICall.stopAndClearRequests(sessions: &donatedGiftsSessions, tasks: &donatedGiftsTasks)
            isLoadingDonatedGifts_ForLazyLoading=false
            getDonatedGifts(index: 0)
        }
        
    }
    
    var donatedGiftsSessions:[URLSession?]=[]
    var donatedGiftsTasks:[URLSessionDataTask?]=[]
    
    func getDonatedGifts(index:Int){
        
        self.initialDonatedGiftsLoadingHasOccurred=true
        
        if isLoadingDonatedGifts_ForLazyLoading {
            return
        }
        isLoadingDonatedGifts_ForLazyLoading=true
        
        if index==0 {
            self.donatedInitialLoadingIndicator?.startLoading()
        } else {
            setTableViewLazyLoading(isLoading: true, type: .donated)
        }
        
        guard let userId=KeychainSwift().get(AppConstants.USER_ID) else {
            return
        }
        let url=APIURLs.getMyDonatedGifts+"/"+userId+"/\(index)/\(index+lazyLoadingCount)"
        
        let input:APIEmptyInput?=nil
        
        isLoadingDonatedGifts = true
        
        APICall.request(url: url, httpMethod: .GET, input: input, sessions: &donatedGiftsSessions, tasks: &donatedGiftsTasks) { [weak self] (data, response, error) in
            
            self?.isLoadingDonatedGifts = false
            
            if let reply=APIRequest.readJsonData(data: data, outputType: [Gift].self) {
                
                if index==0 {
                    self?.donatedGifts=[]
                    self?.donatedGiftsTableView.reloadData()
                }
                
                self?.donatedRefreshControl.endRefreshing()
                self?.donatedInitialLoadingIndicator?.stopLoading()
                self?.setTableViewLazyLoading(isLoading: false, type: .donated)
                
                if reply.count == self?.lazyLoadingCount {
                    self?.isLoadingDonatedGifts_ForLazyLoading=false
                }
                
                var insertedIndexes=[IndexPath]()
                if let minCount = self?.registeredGifts.count {
                    for i in minCount..<minCount+reply.count {
                        insertedIndexes.append(IndexPath(item: i, section: 0))
                    }
                }
                
                self?.donatedGifts.append(contentsOf: reply)
                self?.hideOrShowCorrespondingViewOfSegmentControl(type: self?.currentSegment ?? .registered)
//                self?.showMessage()
//                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(1), execute: {
                    UIView.performWithoutAnimation {
                        self?.donatedGiftsTableView.insertRows(at: insertedIndexes, with: .bottom)
                    }
//                })
            }
        }
        
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
        
        let controller = GiftDetailViewController(nibName: "GiftDetailViewController", bundle: Bundle(for: GiftDetailViewController.self))
        
        switch tableView {
        case registeredGiftsTableView:
            controller.gift = registeredGifts[indexPath.row]
        case donatedGiftsTableView:
            controller.gift = donatedGifts[indexPath.row]
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
    
    func reloadPage(){
        self.reloadRegisteredGifts()
        self.reloadDonatedGifts()
    }
    func reloadOtherVCs(){
        if let home=((self.tabBarController?.viewControllers?[TabIndex.HOME] as? UINavigationController)?.viewControllers.first) as? HomeViewController {
            home.reloadPage()
        }
    }
}
extension MyGiftsViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView {
        case registeredGiftsTableView:
            return registeredGifts.count
        case donatedGiftsTableView:
            return donatedGifts.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell=tableView.dequeueReusableCell(withIdentifier: GiftTableViewCell.identifier, for: indexPath) as! GiftTableViewCell
        
        switch tableView {
        case registeredGiftsTableView:
            
            cell.filViews(gift: registeredGifts[indexPath.row])
            
            let index=indexPath.row+1
            if index==self.registeredGifts.count {
                if !self.isLoadingRegisteredGifts_ForLazyLoading {
                    getRegisteredGifts(index: index)
                }
            }
            
            return cell
            
        case donatedGiftsTableView:
            
            cell.filViews(gift: donatedGifts[indexPath.row])
            
            let index=indexPath.row+1
            if index==self.donatedGifts.count {
                if !self.isLoadingDonatedGifts_ForLazyLoading {
                    getDonatedGifts(index: index)
                }
            }
            
            return cell
            
        default:
            fatalError()
        }
    }
    
    
}
