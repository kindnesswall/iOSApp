//
//  MyGiftsViewController.swift
//  app
//
//  Created by AmirHossein on 3/2/18.
//  Copyright © 2018 Hamed.Gh. All rights reserved.
//

import UIKit

class MyGiftsViewController: UIViewController {

    @IBOutlet weak var segmentControl: UISegmentedControl!
    
    @IBOutlet weak var registeredGiftsTableView: UITableView!
    @IBOutlet weak var donatedGiftsTableView: UITableView!
    
    var registeredGifts=[Gift]()
    var donatedGifts=[Gift]()
    
    var lazyLoadingCount=10
    var isLoadingRegisteredGifts=false
    var isLoadingDonatedGifts=false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registeredGiftsTableView.registerNib(type: GiftTableViewCell.self, nib: "GiftTableViewCell")
        donatedGiftsTableView.registerNib(type: GiftTableViewCell.self, nib: "GiftTableViewCell")
        
        configSegmentControl()
        hideOrShowCorrespondingViewOfSegmentControl(type: .registered)
        
        getRegisteredGifts(index:0)
        getDonatedGifts(index:0)
        

        // Do any additional setup after loading the view.
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
    
    func reloadRegisteredGifts(){
        APICall.stopAndClearRequests(sessions: &registeredGiftsSessions, tasks: &registeredGiftsTasks)
        isLoadingRegisteredGifts=false
        getRegisteredGifts(index: 0)
    }
    
    var registeredGiftsSessions:[URLSession?]=[]
    var registeredGiftsTasks:[URLSessionDataTask?]=[]
    func getRegisteredGifts(index:Int){
        
        if isLoadingRegisteredGifts {
            return
        }
        isLoadingRegisteredGifts=true
        
        if index==0 {
            self.registeredGifts=[]
            self.registeredGiftsTableView.reloadData()
        }
        
        guard let userId=UserDefaults.standard.string(forKey: AppConstants.USER_ID) else {
            return
        }
        let url=APIURLs.getMyRegisteredGifts+"/"+userId+"/\(index)/\(index+lazyLoadingCount)"
        
        let input:APIEmptyInput?=nil
        
        APICall.request(url: url, httpMethod: .GET, input: input , sessions: &registeredGiftsSessions, tasks: &registeredGiftsTasks) { (data, response, error) in
            
            if let reply=APIRequest.readJsonData(data: data, outputType: [Gift].self) {
                
                self.registeredGifts.append(contentsOf: reply)
                
                if reply.count == self.lazyLoadingCount {
                    self.isLoadingRegisteredGifts=false
                }
                
                self.registeredGiftsTableView.reloadData()
                
            }
        }
        
    }
    
    func reloadDonatedGifts(){
        APICall.stopAndClearRequests(sessions: &donatedGiftsSessions, tasks: &donatedGiftsTasks)
        isLoadingDonatedGifts=false
        getDonatedGifts(index: 0)
    }
    
    var donatedGiftsSessions:[URLSession?]=[]
    var donatedGiftsTasks:[URLSessionDataTask?]=[]
    func getDonatedGifts(index:Int){
        
        if isLoadingDonatedGifts {
            return
        }
        isLoadingDonatedGifts=true
        
        if index==0 {
            self.donatedGifts=[]
            self.donatedGiftsTableView.reloadData()
        }
        
        guard let userId=UserDefaults.standard.string(forKey: AppConstants.USER_ID) else {
            return
        }
        let url=APIURLs.getMyDonatedGifts+"/"+userId+"/\(index)/\(index+lazyLoadingCount)"
        
        let input:APIEmptyInput?=nil
        
        APICall.request(url: url, httpMethod: .GET, input: input, sessions: &donatedGiftsSessions, tasks: &donatedGiftsTasks) { (data, response, error) in
            
            if let reply=APIRequest.readJsonData(data: data, outputType: [Gift].self) {
                
                self.donatedGifts.append(contentsOf: reply)
                
                if reply.count == self.lazyLoadingCount {
                    self.isLoadingDonatedGifts=false
                }
                
                self.donatedGiftsTableView.reloadData()
            }
        }
        
    }
    
    func configSegmentControl(){
        self.segmentControl.tintColor=AppColor.tintColor
        self.segmentControl.setTitleTextAttributes([NSAttributedStringKey.font:AppFont.getLightFont(size: 13)], for: .normal)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NavigationBarStyle.setDefaultStyle(navigationC: navigationController)
        self.navigationItem.title="هدیه‌های من"
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
