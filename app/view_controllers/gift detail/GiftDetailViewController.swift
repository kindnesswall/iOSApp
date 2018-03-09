//
//  GiftDetailViewController.swift
//  app
//
//  Created by Hamed.Gh on 12/1/17.
//  Copyright © 2017 Hamed.Gh. All rights reserved.
//

import UIKit
import ImageSlideshow

class GiftDetailViewController: UIViewController {

    var gift:Gift?
    var sdWebImageSource:[SDWebImageSource] = []
    var profileImages:[String] = []

    @IBOutlet var giftNamelbl: UILabel!
    
    @IBOutlet var giftDatelbl: UILabel!
    
    @IBOutlet var giftCategory: UILabel!
    
    @IBOutlet var giftAddress: UILabel!
    
    @IBOutlet var oldOrNewlbl: UILabel!
    
    @IBOutlet var descriptionlbl: UILabel!
    
    @IBOutlet var requestBtn: UIButton!
    
    @IBOutlet var slideshow: ImageSlideshow!
    
    @IBOutlet weak var removeBtn: UIButton!
    
    var loadingIndicator:LoadingIndicator?
    var editBtn:UIBarButtonItem?
    
    @IBAction func requestBtnClicked(_ sender: Any) {
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()

        // Do any additional setup after loading the view.
        giftNamelbl.text = gift?.title
        if let date = gift?.createDateTime {
        giftDatelbl.text = UIFunctions.CastNumberToPersian(input: date)
        }
        giftCategory.text = gift?.category
        giftAddress.text = gift?.address
        if let isNew = gift?.isNew, isNew {
            oldOrNewlbl.text = "نو"
        }else{
            oldOrNewlbl.text = "دسته دوم"
        }
        descriptionlbl.text = gift?.description
        
        createSlideShow()
        
        
        
        guard let id = gift?.id else {
            return
        }
        ApiMethods.getGift(giftId: id) { [weak self] (data) in
            
            if let reply=APIRequest.readJsonData(data: data, outputType: Gift.self) {
                
                self?.loadingIndicator?.stopLoading()
                
                if let myId=UserDefaults.standard.string(forKey: AppConstants.USER_ID) , let userId=reply.userId , myId==userId {
                    self?.addEditBtn()
                    self?.requestBtn.isHidden=true
                    self?.removeBtn.isHidden=false
                } else {
                    self?.requestBtn.isHidden=false
                    self?.removeBtn.isHidden=true
                }
                
            }
            
            
        }
    }
    
    func addEditBtn(){
        editBtn = NavigationBarStyle.getNavigationItem(target: self, action: #selector(self.editBtnClicked), text: "ویرایش",font:AppFont.getRegularFont(size: 16))
        self.navigationItem.rightBarButtonItems=[editBtn!]
    }
    
    func setUI(){
        
        self.removeBtn.isHidden=true
        self.requestBtn.isHidden=true
        
        self.loadingIndicator=LoadingIndicator(navigationItem: self.navigationItem, type: .right, replacedNavigationBarButton: nil)
        self.loadingIndicator?.startLoading()
        
    }
    
    @objc func editBtnClicked(){
        
    }
    @IBAction func removeBtnClicked(_ sender: Any) {
    }
    
    @objc func didTap() {
        let fullScreenController = slideshow.presentFullScreenController(from: self)
        // set the activity indicator for full screen controller (skipping the line will show no activity indicator)
        fullScreenController.slideshow.activityIndicator = DefaultActivityIndicator(style: .white, color: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NavigationBarStyle.setDefaultStyle(navigationC: navigationController)
    }
    
    func createSlideShow() {
        
        guard let images = gift?.giftImages
            else {
            return
        }
        // Do any additional setup after loading the view.
        slideshow.backgroundColor = UIColor.white
        slideshow.slideshowInterval = 5.0
        slideshow.pageControlPosition = PageControlPosition.underScrollView
        slideshow.pageControl.currentPageIndicatorTintColor = UIColor.lightGray
        slideshow.pageControl.pageIndicatorTintColor = UIColor.black
        slideshow.contentScaleMode = UIViewContentMode.scaleAspectFit
        
        // optional way to show activity indicator during image load (skipping the line will show no activity indicator)
        slideshow.activityIndicator = DefaultActivityIndicator()
        slideshow.currentPageChanged = { page in
            
        }
        
        // can be used with other sample sources as `afNetworkingSource`, `alamofireSource` or `sdWebImageSource` or `kingfisherSource`
        
        
        for img in images {
            self.sdWebImageSource.append(
                SDWebImageSource(urlString: img)!
            )
        }
        
        self.slideshow.setImageInputs(self.sdWebImageSource)
        
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(GiftDetailViewController.didTap))
        slideshow.addGestureRecognizer(recognizer)
        
    }
}
