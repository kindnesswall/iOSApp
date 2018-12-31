//
//  RegisterGiftViewController.swift
//  app
//
//  Created by Hamed.Gh on 12/12/17.
//  Copyright © 2017 Hamed.Gh. All rights reserved.
//

import UIKit
import CropViewController

class RegisterGiftViewController: UIViewController {

    @IBOutlet weak var contentScrollView: UIScrollView!
    @IBOutlet weak var titleTextView: UITextField!
    @IBOutlet weak var contentStackView: UIStackView! {
        didSet{
            let tapGesture=UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyBoard))
            contentStackView.addGestureRecognizer(tapGesture)
        }
    }
    
    @IBOutlet weak var categoryBtn: UIButton!
    
    @IBOutlet weak var dateStatusBtn: UIButton!
    
    @IBOutlet weak var priceTextView: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    @IBOutlet weak var editBtn: UIButton!
    @IBOutlet weak var registerBtn: UIButton!
    
    @IBOutlet weak var uploadedImageStack: UIStackView!
    var uploadedImageViews=[UploadImageView]()
    
    var imagesUrl:[String] = []
    
    @IBOutlet weak var placesStackView: UIStackView!
    var placesLabels=[UILabel]()
    
    @IBOutlet weak var placeBtn: UIButton!
    
    @IBOutlet var uploadBtn: UIButton!
    
    var viewModel = RegisterGiftViewModel()
    
    let imagePicker = UIImagePickerController()
    var isEditMode=false
    
    @IBOutlet weak var editedGiftOriginalAddress: UILabel!

    var editHandler:(()->Void)?
    
    var barClearBtn:UIBarButtonItem?
    var barSaveBtn:UIBarButtonItem?
    var barCloseBtn:UIBarButtonItem?
    
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var placeLabel: UILabel!
    @IBOutlet weak var newOrSecondhandLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    deinit {
        print("RegisterGiftViewController Deinit")
        removeKeyboardObserver()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.viewModel.delegate = self
        
        self.configNavBar()
        
        self.configSendButtons()
        
        if isEditMode {
            self.viewModel.readFromEditedGift()
            self.viewModel.giftHasNewAddress=false
        } else {
            self.viewModel.readFromDraft()
            self.viewModel.giftHasNewAddress=true
        }
        
        self.configAddressViews()
        
        addKeyboardObserver()
    }
    
    func configSendButtons(){
        if isEditMode {
            self.registerBtn.hide()
            self.editBtn.show()
        } else {
            self.registerBtn.show()
            self.editBtn.hide()
        }
    }
    
    func configAddressViews(){
        if self.viewModel.giftHasNewAddress {
            self.editedGiftOriginalAddress.hide()
        } else {
            self.editedGiftOriginalAddress.show()
        }
    }
    
    func configNavBar(){
        
        if !isEditMode {
            self.barClearBtn=UINavigationItem.getNavigationItem(target: self, action: #selector(self.clearAllInput), text: LocalizationSystem.getStr(forKey: LanguageKeys.clearPage))
            self.navigationItem.rightBarButtonItems=[self.barClearBtn!]
            self.barSaveBtn=UINavigationItem.getNavigationItem(target: self, action: #selector(self.saveBarBtnAction), text: LocalizationSystem.getStr(forKey: LanguageKeys.saveDraft))
            self.navigationItem.leftBarButtonItems=[self.barSaveBtn!]
            
        } else {
            self.barCloseBtn=UINavigationItem.getNavigationItem(target: self, action: #selector(self.closeBarBtnAction), text: LocalizationSystem.getStr(forKey: LanguageKeys.cancel))
            
            self.navigationItem.rightBarButtonItems=[self.barCloseBtn!]
        }
        
    }
    
    @objc func clearAllInput(){
        
        self.clearUploadedImages()
        self.clearGiftPlaces()
        
        self.categoryBtn.setTitle(LocalizationSystem.getStr(forKey: LanguageKeys.select), for: .normal)
        self.viewModel.category=nil
        
        self.dateStatusBtn.setTitle(LocalizationSystem.getStr(forKey: LanguageKeys.select), for: .normal)
        self.viewModel.dateStatus=nil
        
        self.titleTextView.text=""
        self.descriptionTextView.text=""
        self.priceTextView.text=""
        
        let userDefault=UserDefaults.standard
        userDefault.set(nil, forKey: AppConst.UserDefaults.RegisterGiftDraft)
        userDefault.synchronize()
    }
    
    @objc func saveBarBtnAction(){
        self.viewModel.saveDraft()
    }
    
    @objc func closeBarBtnAction(){
        self.dismiss(animated: true, completion: nil)
    }
    
    func addGiftPlace(place:Place) {
        
        let label=UILabel()
        label.text=place.name
        label.backgroundColor=AppConst.Resource.Color.GreyBg
        label.textColor=UIColor.black
        label.font=AppConst.Resource.Font.getRegularFont(size: 17)
        label.textAlignment = .center
        placesLabels.append(label)
        
        let width=label.intrinsicContentSize.width + 20
        label.widthAnchor.constraint(equalToConstant: width).isActive=true
        
        placesStackView.addArrangedSubview(label)
    }
    
    func clearGiftPlaces(){
        for placeLabel in placesLabels {
            placeLabel.removeFromSuperview()
        }
        placesLabels=[]
        self.viewModel.places=[]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NavigationBarStyle.setDefaultStyle(navigationC: navigationController)
//        setAllTextsInView()
    }
    
    func setAllTextsInView(){
        if isEditMode {
            self.navigationItem.title=LocalizationSystem.getStr(forKey: LanguageKeys.EditGiftViewController_title)
        } else {
            self.navigationItem.title=LocalizationSystem.getStr(forKey: LanguageKeys.RegisterGiftViewController_title)
            
        }
        
        self.barClearBtn?.title=LocalizationSystem.getStr(forKey: LanguageKeys.clearPage)
        self.barSaveBtn?.title=LocalizationSystem.getStr(forKey: LanguageKeys.saveDraft)
        self.barCloseBtn?.title=LocalizationSystem.getStr(forKey: LanguageKeys.cancel)
        
        self.categoryLabel.text=LocalizationSystem.getStr(forKey: LanguageKeys.giftCategory)
        self.titleLabel.text=LocalizationSystem.getStr(forKey: LanguageKeys.title)
        self.descriptionLabel.text=LocalizationSystem.getStr(forKey: LanguageKeys.description)
        self.placeLabel.text=LocalizationSystem.getStr(forKey: LanguageKeys.placeOfTheGift)
        self.newOrSecondhandLabel.text=LocalizationSystem.getStr(forKey: LanguageKeys.newOrUsed)
        self.priceLabel.text=LocalizationSystem.getStr(forKey: LanguageKeys.approximatePrice)+LocalizationSystem.getStr(forKey: LanguageKeys.gettingPriceReason)
        
        self.registerBtn.setTitle(LocalizationSystem.getStr(forKey: LanguageKeys.RegisterGiftViewController_title), for: .normal)
        
        self.editBtn.setTitle(
            LocalizationSystem.getStr(forKey: LanguageKeys.EditGiftViewController_title),
            for: .normal)
        
        self.uploadBtn.setTitle(LocalizationSystem.getStr(forKey: LanguageKeys.addImage), for: .normal)
        self.placeBtn.setTitle(LocalizationSystem.getStr(forKey: LanguageKeys.select), for: .normal)
        if self.viewModel.category == nil {
            self.categoryBtn.setTitle(LocalizationSystem.getStr(forKey: LanguageKeys.select), for: .normal)
        }
        if self.viewModel.dateStatus == nil {
            self.dateStatusBtn.setTitle(LocalizationSystem.getStr(forKey: LanguageKeys.select), for: .normal)
        }
    }
}


