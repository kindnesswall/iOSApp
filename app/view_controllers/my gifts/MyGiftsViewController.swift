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

    @IBOutlet weak var segmentControl: UISegmentedControl!
    
    @IBOutlet weak var registeredGiftsTableView: UITableView!
    @IBOutlet weak var donatedGiftsTableView: UITableView!
    
    var registeredGifts=[Gift]()
    var donatedGifts=[Gift]()
    
    var registeredInitialLoadingIndicator:LoadingIndicator?
    var donatedInitialLoadingIndicator:LoadingIndicator?
    var lazyLoadingCount=20
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registeredGiftsTableView.registerNib(type: GiftTableViewCell.self, nib: "GiftTableViewCell")
        donatedGiftsTableView.registerNib(type: GiftTableViewCell.self, nib: "GiftTableViewCell")
        
        self.registeredInitialLoadingIndicator=LoadingIndicator(view: self.registeredGiftsTableView)
        self.donatedInitialLoadingIndicator=LoadingIndicator(view: self.donatedGiftsTableView)
        self.registeredLazyLoadingIndicator=LoadingIndicator(viewBelowTableView: self.view, cellHeight: tableViewCellHeight/2)
        self.donatedLazyLoadingIndicator=LoadingIndicator(viewBelowTableView: self.view, cellHeight: tableViewCellHeight/2)
        registeredGiftsTableView.contentInset=UIEdgeInsets(top: 0, left: 0, bottom: tableViewCellHeight/2, right: 0)
        donatedGiftsTableView.contentInset=UIEdgeInsets(top: 0, left: 0, bottom: tableViewCellHeight/2, right: 0)
        
        configRefreshControl()
        
        configSegmentControl()
        hideOrShowCorrespondingViewOfSegmentControl(type: .registered)
        
        getRegisteredGifts(index:0)
        getDonatedGifts(index:0)
        

        // Do any additional setup after loading the view.
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
        
        if type == .registered {
            self.registeredGiftsTableView.isHidden=false
        } else {
            self.registeredGiftsTableView.isHidden=true
        }
        
        if type == .donated {
            self.donatedGiftsTableView.isHidden=false
        } else {
            self.donatedGiftsTableView.isHidden=true
        }
        
    }
    
    enum SegmentControlViewType {
        case registered
        case donated
    }
    
    var initialRegisteredGiftsLoadingHasOccurred=false
    func reloadRegisteredGifts(){
        
        if self.initialRegisteredGiftsLoadingHasOccurred {
            APICall.stopAndClearRequests(sessions: &registeredGiftsSessions, tasks: &registeredGiftsTasks)
            isLoadingRegisteredGifts=false
            getRegisteredGifts(index: 0)
        }
        
    }
    
    var registeredGiftsSessions:[URLSession?]=[]
    var registeredGiftsTasks:[URLSessionDataTask?]=[]
    
    func getRegisteredGifts(index:Int){
        
        self.initialRegisteredGiftsLoadingHasOccurred=true
        
        if isLoadingRegisteredGifts {
            return
        }
        isLoadingRegisteredGifts=true
        
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
        
        APICall.request(url: url, httpMethod: .GET, input: input , sessions: &registeredGiftsSessions, tasks: &registeredGiftsTasks) { (data, response, error) in
            
            if let reply=APIRequest.readJsonData(data: data, outputType: [Gift].self) {
                
                if index==0 {
                    self.registeredGifts=[]
                    self.registeredGiftsTableView.reloadData()
                }
                
                self.registeredRefreshControl.endRefreshing()
                self.registeredInitialLoadingIndicator?.stopLoading()
                self.setTableViewLazyLoading(isLoading: false, type: .registered)

                
                if reply.count == self.lazyLoadingCount {
                    self.isLoadingRegisteredGifts=false
                }
                
                var insertedIndexes=[IndexPath]()
                for i in self.registeredGifts.count..<self.registeredGifts.count+reply.count {
                    insertedIndexes.append(IndexPath(item: i, section: 0))
                }
                
                self.registeredGifts.append(contentsOf: reply)
                
//                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(1), execute: {
                    UIView.performWithoutAnimation {
                        self.registeredGiftsTableView.insertRows(at: insertedIndexes, with: .bottom)
                    }
//                })
                
            }
        }
        
    }
    
    var initialDonatedGiftsLoadingHasOccurred=false
    func reloadDonatedGifts(){
        
        if self.initialDonatedGiftsLoadingHasOccurred {
            APICall.stopAndClearRequests(sessions: &donatedGiftsSessions, tasks: &donatedGiftsTasks)
            isLoadingDonatedGifts=false
            getDonatedGifts(index: 0)
        }
        
    }
    
    var donatedGiftsSessions:[URLSession?]=[]
    var donatedGiftsTasks:[URLSessionDataTask?]=[]
    
    func getDonatedGifts(index:Int){
        
        self.initialDonatedGiftsLoadingHasOccurred=true
        
        if isLoadingDonatedGifts {
            return
        }
        isLoadingDonatedGifts=true
        
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
        
        APICall.request(url: url, httpMethod: .GET, input: input, sessions: &donatedGiftsSessions, tasks: &donatedGiftsTasks) { (data, response, error) in
            
            if let reply=APIRequest.readJsonData(data: data, outputType: [Gift].self) {
                
                if index==0 {
                    self.donatedGifts=[]
                    self.donatedGiftsTableView.reloadData()
                }
                
                self.donatedRefreshControl.endRefreshing()
                self.donatedInitialLoadingIndicator?.stopLoading()
                self.setTableViewLazyLoading(isLoading: false, type: .donated)
                
                if reply.count == self.lazyLoadingCount {
                    self.isLoadingDonatedGifts=false
                }
                
                var insertedIndexes=[IndexPath]()
                for i in self.donatedGifts.count..<self.donatedGifts.count+reply.count {
                    insertedIndexes.append(IndexPath(item: i, section: 0))
                }
                
                self.donatedGifts.append(contentsOf: reply)
                
//                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(1), execute: {
                    UIView.performWithoutAnimation {
                        self.donatedGiftsTableView.insertRows(at: insertedIndexes, with: .bottom)
                    }
//                })
            }
        }
        
    }
    
    func configSegmentControl(){
        self.segmentControl.tintColor=AppColor.tintColor
        self.segmentControl.setTitleTextAttributes([NSAttributedStringKey.font:AppFont.getLightFont(size: 13)], for: .normal)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NavigationBarStyle.setDefaultStyle(navigationC: navigationController)
        self.setAllTextsInView()
    }
    
    func setAllTextsInView(){
        self.navigationItem.title=AppLiteral.myGifts
        self.segmentControl.setTitle(AppLiteral.donated, forSegmentAt: 0)
        self.segmentControl.setTitle(AppLiteral.registered, forSegmentAt: 1)
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
        
        switch tableView {
        case registeredGiftsTableView:
            let cell=tableView.dequeueReusableCell(withIdentifier: "GiftTableViewCell", for: indexPath) as! GiftTableViewCell
            cell.filViews(gift: registeredGifts[indexPath.row])
            
            let index=indexPath.row+1
            if index==self.registeredGifts.count {
                if !self.isLoadingRegisteredGifts {
                    getRegisteredGifts(index: index)
                }
            }
            
            return cell
            
        case donatedGiftsTableView:
            let cell=tableView.dequeueReusableCell(withIdentifier: "GiftTableViewCell", for: indexPath) as! GiftTableViewCell
            cell.filViews(gift: donatedGifts[indexPath.row])
            
            let index=indexPath.row+1
            if index==self.donatedGifts.count {
                if !self.isLoadingDonatedGifts {
                    getDonatedGifts(index: index)
                }
            }
            
            return cell
            
        default:
            fatalError()
        }
    }
    
    
}
