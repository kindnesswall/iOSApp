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
import Kingfisher
//import ImageSlideshow;/Kingfisher

class GiftDetailViewController: UIViewController {

    var gift:Gift?
//    var sdWebImageSource:[SDWebImageSource] = []
    var profileImages:[String] = []
//    var loadingIndicator:LoadingIndicator?
    var editBtn:UIBarButtonItem?
    
    var editHandler:(()->Void)?
    
    var vm = GiftDetailVM()
    
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
    
    deinit {
        print("GiftDetailViewController deinit")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()

        
        createSlideShow()
        
        fillUIWithGift()
        
        
//        self.loadingIndicator?.stopLoading()
        
        if let myIdString=KeychainSwift().get(AppConst.KeyChain.USER_ID), let myId=Int(myIdString), let userId=gift?.userId, myId==userId {
            self.addEditBtn()
            //                    self?.requestBtn.hide()
            self.removeBtn.show()
        } else {
            //                    self?.requestBtn.show()
            self.removeBtn.hide()
        }
        
        
    }
    
    func fillUIWithGift(){
        
        giftNamelbl.text = gift?.title
        if let date = gift?.createdAt?.convertToDate()?.getPersianDate() {
            giftDatelbl.text = AppLanguage.getNumberString(number: date)
        }
        giftCategory.text = gift?.categoryTitle
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
            font:AppConst.Resource.Font.getRegularFont(size: 16)
        )
        
        self.navigationItem.rightBarButtonItems=[editBtn!]
    }
    
    func setUI(){
        
        self.removeBtn.hide()
//        self.requestBtn.hide()
        
//        self.loadingIndicator=LoadingIndicator(navigationItem: self.navigationItem, type: .right, replacedNavigationBarButton: nil)
//        self.loadingIndicator?.startLoading()
        
    }
    
    @IBAction func requestBtnClicked(_ sender: Any) {
        guard AppDelegate.me().checkForLogin() else {
            return
        }
        
        self.requestGift()
        
    }
    
    @objc func editBtnClicked(){
        
        let controller=RegisterGiftViewController()
        
        controller.isEditMode=true
        controller.vm.editedGift=self.gift
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
    
    func requestGift(){
        guard let giftId = gift?.id else {
            return
        }
        self.requestBtn.isEnabled = false
        
        vm.requestGift(id: giftId, onSuccess: { [weak self] (chatId) in
            self?.sendRequestMessage(chatId: chatId)
            self?.requestBtn.isEnabled = true
            
        }) { [weak self] in
            self?.requestBtn.isEnabled = true
        }
        
    }
    
    func removeGift(){
        
        guard let giftId=gift?.id else {
            return
        }
        self.removeBtn.isEnabled=false
        
        vm.removeGift(id: giftId, onSuccess: { [weak self] in
            self?.removeBtn.isEnabled=true
            self?.editHandler?()
            self?.navigationController?.popViewController(animated: true)
        }, onFail: { [weak self] in
            self?.removeBtn.isEnabled=true
        })
    }
    
    func sendRequestMessage(chatId:Int){
        
        let text = "درخواست هدیه \(self.gift?.title ?? "")"
        
        let startNewChatProtocol = AppDelegate.me().startNewChatProtocol
        guard let messagesViewModel = startNewChatProtocol?.writeMessage(text: text, chatId: chatId) else {
            return
        }
        guard let messagesViewControllerDelegate = startNewChatProtocol?.getMessagesViewControllerDelegate() else {
            return
        }
        
        self.pushMessagesViewController(messagesViewModel: messagesViewModel, messagesViewControllerDelegate: messagesViewControllerDelegate)
    }
    
    func pushMessagesViewController(messagesViewModel: MessagesViewModel,
                                    messagesViewControllerDelegate:MessagesViewControllerDelegate){
        
        let controller = MessagesViewController()
        controller.viewModel = messagesViewModel
        controller.delegate = messagesViewControllerDelegate
        controller.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(controller, animated: true)
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
        
        var sdWebImageSource:[KingfisherSource] = []
        for img in images {
            if let source = KingfisherSource(urlString: img) {
                sdWebImageSource.append(source)
            }
        }
        
        self.slideshow.setImageInputs(sdWebImageSource)
    }
}
