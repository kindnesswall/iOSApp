//
//  GiftDetailViewController.swift
//  app
//
//  Created by Hamed.Gh on 12/1/17.
//  Copyright © 2017 Hamed.Gh. All rights reserved.
//

import UIKit
import ImageSlideshow
import KeychainSwift

class GiftDetailViewController: UIViewController {

    var gift:Gift?
    var sdWebImageSource:[SDWebImageSource] = []
    var profileImages:[String] = []
    
    var editHandler:(()->Void)?
    
    @IBOutlet weak var oldOrNewLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet var giftNamelbl: UILabel!
    
    @IBOutlet var giftDatelbl: UILabel!
    
    @IBOutlet var giftCategory: UILabel!
    
    @IBOutlet var giftAddress: UILabel!
    
    @IBOutlet var oldOrNew: UILabel!
    
    @IBOutlet var giftDescription: UILabel!
    
    @IBOutlet var requestBtn: UIButton!
    
    @IBOutlet var slideshow: ImageSlideshow!
    
    @IBOutlet weak var removeBtn: UIButton!
    
    var loadingIndicator:LoadingIndicator?
    var editBtn:UIBarButtonItem?
    
    deinit {
        print("GiftDetailViewController deinit")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()

        if let _=KeychainSwift().get(AppConstants.Authorization) {
            self.requestBtn.hide()
        }
        
        createSlideShow()
        
        fillUIWithGift()
        
        guard let id = gift?.id else {
            return
        }
        ApiMethods.getGift(giftId: id) { [weak self] (data) in
            
            if let reply=APIRequest.readJsonData(data: data, outputType: Gift.self) {
                
                self?.loadingIndicator?.stopLoading()
                
                if let myId=KeychainSwift().get(AppConstants.USER_ID) , let userId=reply.userId , myId==userId {
                    self?.addEditBtn()
//                    self?.requestBtn.hide()
                    self?.removeBtn.show()
                } else {
//                    self?.requestBtn.show()
                    self?.removeBtn.hide()
                }
                
            }
            
            
        }
    }
    
    func fillUIWithGift(){
        
        giftNamelbl.text = gift?.title
        if let date = gift?.createDateTime {
            giftDatelbl.text = AppLanguage.getNumberString(number: date)
        }
        giftCategory.text = gift?.category
        giftAddress.text = gift?.address
        if let isNew = gift?.isNew, isNew {
            oldOrNew.text = LocalizationSystem.getStr(forKey: LanguageKeys.new)
        }else{
            oldOrNew.text = LocalizationSystem.getStr(forKey: LanguageKeys.used)
        }
        giftDescription.text = gift?.description
        
        addImagesToSlideShows()
    }
    
    func addEditBtn(){
        editBtn = NavigationBarStyle.getNavigationItem(
            target: self,
            action: #selector(self.editBtnClicked),
            text:LocalizationSystem.getStr(forKey: LanguageKeys.edit),
            font:AppFont.getRegularFont(size: 16)
        )
        
        self.navigationItem.rightBarButtonItems=[editBtn!]
    }
    
    func setUI(){
        
        self.removeBtn.hide()
//        self.requestBtn.hide()
        
        self.loadingIndicator=LoadingIndicator(navigationItem: self.navigationItem, type: .right, replacedNavigationBarButton: nil)
        self.loadingIndicator?.startLoading()
        
    }
    
    @IBAction func requestBtnClicked(_ sender: Any) {
        guard AppDelegate.me().checkForLogin() else {
            return
        }
    }
    
    @objc func editBtnClicked(){
        
        let controller=RegisterGiftViewController()
        
        controller.isEditMode=true
        controller.editedGift=self.gift
        controller.editHandler={ [weak self] in
            
            self?.fillUIWithGift()
            self?.editHandler?()
            
        }
        
        let nc=UINavigationController(rootViewController: controller)
        
        self.present(nc, animated: true, completion: nil)
        
    }
    @IBAction func removeBtnClicked(_ sender: Any) {
        
        PopUpMessage.showPopUp(nibClass: PromptUser.self, data: LocalizationSystem.getStr(forKey: LanguageKeys.giftRemovingPrompt),animation:.none,declineHandler: nil) { (ـ) in
            self.removeGift()
        }
        
    }
    
    func removeGift(){
        
        self.removeBtn.isEnabled=false
        guard let giftId=gift?.id else {
            return
        }
        var input:APIEmptyInput?=nil
        var url=APIURLs.Gift
        url+="/\(giftId)"
        APICall.request(url: url, httpMethod: .DELETE, input: input) { [weak self] (data, response, error) in
            self?.removeBtn.isEnabled=true
            
            if let error = error {
                FlashMessage.showMessage(body: LocalizationSystem.getStr(forKey: LanguageKeys.operationFailed),theme: .error)
                return
            }
            
            if let response = response as? HTTPURLResponse {
                if response.statusCode >= 200 && response.statusCode <= 300 {
                    
                    self?.editHandler?()
                    self?.navigationController?.popViewController(animated: true)
                    
                }else{
                    FlashMessage.showMessage(body: LocalizationSystem.getStr(forKey: LanguageKeys.operationFailed),theme: .error)
                }
            }
        }
    }
    
    @objc func didTap() {
        let fullScreenController = slideshow.presentFullScreenController(from: self)
        // set the activity indicator for full screen controller (skipping the line will show no activity indicator)
        fullScreenController.slideshow.activityIndicator = DefaultActivityIndicator(style: .white, color: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NavigationBarStyle.setDefaultStyle(navigationC: navigationController)
        self.setAllTextsInView()
    }
    
    func setAllTextsInView(){
        self.editBtn?.title=LocalizationSystem.getStr(forKey: LanguageKeys.edit)
        self.removeBtn.setTitle(LocalizationSystem.getStr(forKey: LanguageKeys.remove), for: .normal)
        self.requestBtn.setTitle(
            LocalizationSystem.getStr(forKey: LanguageKeys.request),
            for: .normal)
        
        self.categoryLabel.text=LocalizationSystem.getStr(forKey: LanguageKeys.category)
        self.oldOrNewLabel.text=LocalizationSystem.getStr(forKey: LanguageKeys.status)
        self.addressLabel.text=LocalizationSystem.getStr(forKey: LanguageKeys.address)
        self.descriptionLabel.text=LocalizationSystem.getStr(forKey: LanguageKeys.description)
    }
    
    func createSlideShow() {
        
        
        // Do any additional setup after loading the view.
        slideshow.backgroundColor = UIColor.white
        slideshow.slideshowInterval = 5.0
        slideshow.pageControlPosition = PageControlPosition.underScrollView
        slideshow.pageControl.currentPageIndicatorTintColor = UIColor.lightGray
        slideshow.pageControl.pageIndicatorTintColor = UIColor.black
        slideshow.contentScaleMode = UIView.ContentMode.scaleAspectFit
        
        // optional way to show activity indicator during image load (skipping the line will show no activity indicator)
        slideshow.activityIndicator = DefaultActivityIndicator()
        slideshow.currentPageChanged = { page in
            
        }
        
        // can be used with other sample sources as `afNetworkingSource`, `alamofireSource` or `sdWebImageSource` or `kingfisherSource`
        
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(GiftDetailViewController.didTap))
        slideshow.addGestureRecognizer(recognizer)
        
    }
    
    func addImagesToSlideShows(){
        
        guard let images = gift?.giftImages
            else {
                return
        }
        
        self.sdWebImageSource=[]
        for img in images {
            self.sdWebImageSource.append(
                SDWebImageSource(urlString: img)!
            )
        }
        
        self.slideshow.setImageInputs(self.sdWebImageSource)
    }
}
