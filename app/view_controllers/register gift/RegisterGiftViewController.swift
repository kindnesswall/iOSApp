//
//  RegisterGiftViewController.swift
//  app
//
//  Created by Hamed.Gh on 12/12/17.
//  Copyright © 2017 Hamed.Gh. All rights reserved.
//

import UIKit
import XLActionController
import CropViewController

class RegisterGiftViewController: UIViewController {

    @IBOutlet weak var contentScrollView: UIScrollView!
    @IBOutlet weak var titleTextView: UITextField!
    @IBOutlet weak var contentStackView: UIStackView!
    
    @IBOutlet weak var categoryBtn: UIButton!
    
    @IBOutlet weak var dateStatusBtn: UIButton!
    
    @IBOutlet weak var priceTextView: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    @IBOutlet weak var editBtn: UIButton!
    @IBOutlet weak var registerBtn: UIButton!
    
    @IBOutlet weak var uploadedImageStack: UIStackView!
    var uploadedImageViews=[UploadImageView]()
    
    @IBOutlet weak var placesStackView: UIStackView!
    var placesLabels=[UILabel]()
    
    @IBOutlet weak var placeBtn: UIButton!
    
    @IBOutlet var uploadBtn: UIButton!
    
    var viewModel = RegisterGiftViewModel()
    

    @IBAction func submitBtnAction(_ sender: Any) {
        
        self.registerBtn.isEnabled=false
        viewModel.sendGift(httpMethod: .POST, responseHandler: {
            self.registerBtn.isEnabled=true
        }) {
            self.clearAllInput()
            FlashMessage.showMessage(body: LocalizationSystem.getStr(forKey: LanguageKeys.giftRegisteredSuccessfully),theme: .success)
        }
        
    }
    @IBAction func editBtnAction(_ sender: Any) {
        
        guard let giftId=self.viewModel.editedGift?.id else {
            return
        }
        
        self.editBtn.isEnabled=false
        viewModel.sendGift(httpMethod: .PUT,giftId: giftId, responseHandler: {
            self.editBtn.isEnabled=true
        }) {
            
            FlashMessage.showMessage(body: LocalizationSystem.getStr(forKey: LanguageKeys.editedSuccessfully), theme: .success)
            
            self.viewModel.writeChangesToEditedGift()
            self.editHandler?()
            
            let when=DispatchTime.now() + 1
            DispatchQueue.main.asyncAfter(deadline: when, execute: {
                self.dismiss(animated: true, completion: nil)
            })
            
        }
    }
    
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
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.viewModel.delegate = self
        
        let tapGesture=UITapGestureRecognizer(target: self, action: #selector(self.tapGestureAction))
        
        contentStackView.addGestureRecognizer(tapGesture)
        
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
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        // Do any additional setup after loading the view.
    }
    
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            
            let lastContentOffset=self.contentScrollView.contentOffset
            let offset:CGFloat=60+10+150+10
            if lastContentOffset.y<offset {
                self.contentScrollView.contentOffset=CGPoint(x: lastContentOffset.x, y: offset)
            }
//            print("keyboard:\(keyboardSize.height)")
            self.contentScrollView.contentInset=UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
            
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        
        self.contentScrollView.contentInset=UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
//        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {}
        
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
            self.barClearBtn=UINavigationItem.getNavigationItem(target: self, action: #selector(self.clearBarBtnAction), text: LocalizationSystem.getStr(forKey: LanguageKeys.clearPage))
            self.navigationItem.rightBarButtonItems=[self.barClearBtn!]
            self.barSaveBtn=UINavigationItem.getNavigationItem(target: self, action: #selector(self.saveBarBtnAction), text: LocalizationSystem.getStr(forKey: LanguageKeys.saveDraft))
            self.navigationItem.leftBarButtonItems=[self.barSaveBtn!]
            
        } else {
            self.barCloseBtn=UINavigationItem.getNavigationItem(target: self, action: #selector(self.closeBarBtnAction), text: LocalizationSystem.getStr(forKey: LanguageKeys.cancel))
            
            self.navigationItem.rightBarButtonItems=[self.barCloseBtn!]
        }
        
    }
    
    
    func clearAllInput(){
        
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
    
    
    @objc func clearBarBtnAction(){
        self.clearAllInput()
    }
    @objc func saveBarBtnAction(){
        self.viewModel.saveDraft()
    }
    
    @objc func closeBarBtnAction(){
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func tapGestureAction(){
        dismissKeyBoard()
    }
    
    func dismissKeyBoard(){
        self.titleTextView.resignFirstResponder()
        self.priceTextView.resignFirstResponder()
        self.descriptionTextView.resignFirstResponder()
    }

    @IBAction func placeBtnAction(_ sender: Any) {
        
        self.clearGiftPlaces()
        self.viewModel.giftHasNewAddress=true
        self.configAddressViews()
        
        let controller=OptionsListViewController(
            nibName: OptionsListViewController.identifier,
            bundle: OptionsListViewController.bundle
        )
        controller.option = OptionsListViewController.Option.city(showRegion: true)
        controller.completionHandler={ [weak self] (id,name) in
            let place=Place(id: Int(id ?? ""), name: name)
            self?.viewModel.places.append(place)
            self?.addGiftPlace(place: place)
        }
        controller.closeHandler={ [weak self] in
            self?.clearGiftPlaces()
        }
        let nc=UINavigationController(rootViewController: controller)
        self.present(nc, animated: true, completion: nil)
    }
    
    func addGiftPlace(place:Place) {
        
        let label=UILabel()
        label.text=place.name
        label.backgroundColor=AppColor.greyBgColor
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
    
    @IBAction func categoryBtnClicked(_ sender: Any) {
        
        let controller=OptionsListViewController(
            nibName: OptionsListViewController.identifier,
            bundle: OptionsListViewController.bundle
        )
        controller.option = OptionsListViewController.Option.category
        controller.completionHandler={ [weak self] (id,name) in
            self?.categoryBtn.setTitle(name, for: .normal)
            self?.viewModel.category=Category(id: id, title: name)
        }
        let nc=UINavigationController(rootViewController: controller)
        self.present(nc, animated: true, completion: nil)
    }
    
    @IBAction func dateStatusBtnAction(_ sender: Any) {
        let controller=OptionsListViewController(
            nibName: OptionsListViewController.identifier,
            bundle: OptionsListViewController.bundle
        )
        controller.option = OptionsListViewController.Option.dateStatus
        controller.completionHandler={ [weak self] (id,name) in
            self?.dateStatusBtn.setTitle(name, for: .normal)
            self?.viewModel.dateStatus=DateStatus(id: id, title: name)
        }
        let nc=UINavigationController(rootViewController: controller)
        self.present(nc, animated: true, completion: nil)
    }
    
    @IBAction func uploadBtnClicked(_ sender: Any) {
        let actionController = SkypeActionController()
        
        actionController.addAction(Action(LocalizationSystem.getStr(forKey: LanguageKeys.camera), style: .default, handler: { action in
            
            self.imagePicker.allowsEditing = false
            self.imagePicker.sourceType = .camera
            self.imagePicker.delegate = self
            
            self.present(self.imagePicker, animated: true, completion: nil)
            
        }))
        
        actionController.addAction(Action(LocalizationSystem.getStr(forKey: LanguageKeys.gallery), style: .default, handler: { action in
            
            self.imagePicker.allowsEditing = false
            self.imagePicker.sourceType = .photoLibrary
            self.imagePicker.delegate = self
    
            self.present(self.imagePicker, animated: true, completion: nil)
            
        }))
        
        present(actionController, animated: true, completion: nil)

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

extension RegisterGiftViewController : RegisterGiftViewModelDelegate {
    

    func setUIInputProperties(uiProperties: RegisterGiftViewModel.UIInputProperties) {
        descriptionTextView.text = uiProperties.descriptionTextViewText
        priceTextView.text = uiProperties.priceTextViewText
        titleTextView.text = uiProperties.titleTextViewText
    }
    
    func getUIInputProperties() -> RegisterGiftViewModel.UIInputProperties {
        let uiProperties = RegisterGiftViewModel.UIInputProperties()
        uiProperties.descriptionTextViewText = descriptionTextView.text
        uiProperties.priceTextViewText = priceTextView.text
        uiProperties.titleTextViewText = titleTextView.text
        return uiProperties
        
    }
    
    func getGiftImages()->[String] {
        var giftImages=[String]()
        for uploadedImageView in self.uploadedImageViews {
            if let src=uploadedImageView.imageSrc {
                giftImages.append(src)
            }
        }
        return giftImages
    }
    
    
    func setCategoryBtnTitle(text: String?) {
        self.categoryBtn.setTitle(text, for: .normal)
    }
    
    func setDateStatusBtnTitle(text: String?) {
        self.dateStatusBtn.setTitle(text, for: .normal)
    }
    
    func setEditedGiftOriginalAddressLabel(text: String?) {
        self.editedGiftOriginalAddress.text=text
    }
    
    func addUploadedImageFromEditedGift(giftImage: String) {
        let uploadImageView=self.addUploadImageView(imageSrc: giftImage)
        self.imageViewUploadingHasFinished(uploadImageView: uploadImageView, imageSrc: giftImage)
    }
    
    func addGiftPlaceToUIStack(place: Place) {
        self.addGiftPlace(place: place)
    }
    
}


