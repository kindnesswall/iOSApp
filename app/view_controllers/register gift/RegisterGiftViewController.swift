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

    @IBOutlet weak var titleTextView: UITextField!
    @IBOutlet weak var contentStackView: UIStackView!
    
    @IBOutlet weak var categoryBtn: UIButton!
    var category:Category?
    
    @IBOutlet weak var dateStatusBtn: UIButton!
    var dateStatus:DateStatus?
    
    @IBOutlet weak var priceTextView: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    @IBOutlet weak var editBtn: UIButton!
    @IBOutlet weak var registerBtn: UIButton!
    
    @IBOutlet weak var uploadedImageStack: UIStackView!
    var uploadedImageViews=[UploadImageView]()
    
    @IBOutlet weak var placesStackView: UIStackView!
    var placesLabels=[UILabel]()
    var places=[Place]()
    
    @IBOutlet var uploadBtn: UIButton!

    @IBAction func submitBtnAction(_ sender: Any) {
        
        self.registerBtn.isEnabled=false
        sendGift(httpMethod: .POST, responseHandler: {
            self.registerBtn.isEnabled=true
        }) {
            self.clearAllInput()
            FlashMessage.showMessage(body: "ثبت کالا با موفقیت انجام شد",theme: .success)
        }
        
    }
    @IBAction func editBtnAction(_ sender: Any) {
        
        guard let giftId=editedGift?.id else {
            return
        }
        
        self.editBtn.isEnabled=false
        sendGift(httpMethod: .PUT,giftId: giftId, responseHandler: {
            self.editBtn.isEnabled=true
        }) {
            
            FlashMessage.showMessage(body: "کالا با موفقیت ویرایش شد.", theme: .success)
            
            self.writeChangesToEditedGift()
            self.editHandler?()
            
            let when=DispatchTime.now() + 1
            DispatchQueue.main.asyncAfter(deadline: when, execute: {
                self.dismiss(animated: true, completion: nil)
            })
            
        }
    }
    
    let imagePicker = UIImagePickerController()
    
    var isEditMode=false
    var editedGift:Gift?
    @IBOutlet weak var editedGiftOriginalAddress: UILabel!
    var editedGiftOriginalCityId = 0
    var editedGiftOriginalRegionId = 0
    var giftHasNewAddress=false
    
    var editHandler:(()->Void)?
    
    var barClearBtn:UIBarButtonItem?
    var barSaveBtn:UIBarButtonItem?
    var closeBarBtn:UIBarButtonItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGesture=UITapGestureRecognizer(target: self, action: #selector(self.tapGestureAction))
        
        contentStackView.addGestureRecognizer(tapGesture)
        
        self.configNavBar()
        
        self.configSendButtons()
        
        if isEditMode {
            readFromEditedGift()
            giftHasNewAddress=false
        } else {
            readFromDraft()
            giftHasNewAddress=true
        }
        
        self.configAddressViews()
        
        
        // Do any additional setup after loading the view.
    }
    
    func configSendButtons(){
        if isEditMode {
            self.registerBtn.isHidden=true
            self.editBtn.isHidden=false
        } else {
            self.registerBtn.isHidden=false
            self.editBtn.isHidden=true
        }
    }
    
    func configAddressViews(){
        if giftHasNewAddress {
            self.editedGiftOriginalAddress.isHidden=true
        } else {
            self.editedGiftOriginalAddress.isHidden=false
        }
    }
    
    func configNavBar(){
        
        if !isEditMode {
            self.barClearBtn=UINavigationItem.getNavigationItem(target: self, action: #selector(self.clearBarBtnAction), text: "پاک کردن صفحه")
            self.navigationItem.rightBarButtonItems=[self.barClearBtn!]
            self.barSaveBtn=UINavigationItem.getNavigationItem(target: self, action: #selector(self.saveBarBtnAction), text: "ذخیره پیش‌ نویس")
            self.navigationItem.leftBarButtonItems=[self.barSaveBtn!]
            
        } else {
            self.closeBarBtn=UINavigationItem.getNavigationItem(target: self, action: #selector(self.closeBarBtnAction), text: "انصراف")
            self.navigationItem.rightBarButtonItems=[self.closeBarBtn!]
        }
        
    }
    
    func readFromEditedGift(){
        
        guard let gift=editedGift else {
            return
        }
        
        self.titleTextView.text=gift.title
        self.descriptionTextView.text=gift.description
        self.priceTextView.text=gift.price
        
        self.category=Category(id: gift.categoryId, title: gift.category)
        self.categoryBtn.setTitle(gift.category, for: .normal)
        
        
        if let isNew=gift.isNew {
            if isNew {
                self.dateStatus=DateStatus(id:"0",title:"نو")
            } else {
                self.dateStatus=DateStatus(id: "1" , title: "دسته‌دو")
            }
            self.dateStatusBtn.setTitle(self.dateStatus?.title, for: .normal)
        }
        
        self.editedGiftOriginalAddress.text=gift.address
        self.editedGiftOriginalCityId=Int(gift.cityId ?? "") ?? 0
        self.editedGiftOriginalRegionId=Int(gift.regionId ?? "") ?? 0
        
        if let giftImages = gift.giftImages {
            for giftImage in giftImages {
                let uploadImageView=self.addUploadImageView(imageSrc: giftImage)
                self.imageViewUploadingHasFinished(uploadImageView: uploadImageView, imageSrc: giftImage)
            }
        }
        
    }
    
    func writeChangesToEditedGift(){
        
        guard let gift=editedGift else {
            return
        }
        
        gift.title=self.titleTextView.text
        gift.description=self.descriptionTextView.text
        gift.price=self.priceTextView.text
        
        gift.category=self.category?.title
        gift.categoryId=self.category?.id
        
        if let dateStatusId=self.dateStatus?.id {
            if dateStatusId == "0" {
                gift.isNew=true
            } else {
                gift.isNew=false
            }
        }
        
        if giftHasNewAddress {
            
            let addressObject=getAddress()
            
            let address=addressObject.address
            let cityId=addressObject.cityId
            let regionId=addressObject.regionId
            
            gift.address=address
            gift.cityId=cityId?.description ?? "0"
            gift.regionId=regionId?.description ?? "0"
            
        } else {
            
            gift.address=self.editedGiftOriginalAddress.text
            gift.cityId=self.editedGiftOriginalCityId.description
            gift.regionId=self.editedGiftOriginalRegionId.description
            
        }
        
        let giftImages=getGiftImages()
        gift.giftImages=giftImages
        
    }
    
    func readFromDraft(){
        guard let data = UserDefaults.standard.data(forKey: AppConstants.RegisterGiftDraft) else {
            return
        }
        guard let draft = try? JSONDecoder().decode(RegisterGiftDraft.self, from: data) else {
            return
        }
        
        self.titleTextView.text=draft.title
        self.descriptionTextView.text=draft.description
        self.priceTextView.text=draft.price?.description ?? ""
        
        if let category=draft.category {
            self.category=category
            self.categoryBtn.setTitle(category.title, for: .normal)
        }
        
        if let dateStatus=draft.dateStatus {
            self.dateStatus=dateStatus
            self.dateStatusBtn.setTitle(dateStatus.title, for: .normal)
        }
        
        if let draftPlaces = draft.places {
            for draftPlace in draftPlaces {
                self.places.append(draftPlace)
                self.addGiftPlace(place: draftPlace)
            }
        }
        
        
    }
    
    func clearAllInput(){
        
        self.clearUploadedImages()
        self.clearGiftPlaces()
        
        self.categoryBtn.setTitle("انتخاب", for: .normal)
        self.category=nil
        
        self.dateStatusBtn.setTitle("انتخاب", for: .normal)
        self.dateStatus=nil
        
        self.titleTextView.text=""
        self.descriptionTextView.text=""
        self.priceTextView.text=""
        
        let userDefault=UserDefaults.standard
        userDefault.set(nil, forKey: AppConstants.RegisterGiftDraft)
        userDefault.synchronize()
        
    }
    
    func saveDraft(){
        
        
        let draft=RegisterGiftDraft()
        draft.title=self.titleTextView.text
        draft.description=self.descriptionTextView.text
        draft.price=Int(self.priceTextView.text ?? "")
        draft.category=self.category
        draft.dateStatus=self.dateStatus
        draft.places=self.places
        
        guard let data=try? JSONEncoder().encode(draft) else {
            return
        }
        
        let userDefault=UserDefaults.standard
        userDefault.set(data, forKey: AppConstants.RegisterGiftDraft)
        userDefault.synchronize()
        
        FlashMessage.showMessage(body: "پیش‌نویس با موفقیت ذخیره شد.", theme: .success)
        
    }
    
    
    
    func sendGift(httpMethod:HttpCallMethod,giftId:String?=nil,responseHandler:(()->Void)?,complitionHandler:(()->Void)?){
        
        let input=RegisterGiftInput()
        
        guard let title=self.titleTextView.text , title != "" else {
            FlashMessage.showMessage(body: "لطفا عنوان کالا را وارد نمایید",theme: .warning)
            return
        }
        input.title=title
        
        guard let categoryId=Int(self.category?.id ?? "") else {
            FlashMessage.showMessage(body: "لطفا دسته‌بندی کالا را انتخاب نمایید",theme: .warning)
            return
        }
        input.categoryId=categoryId
        
        
        guard let dateStatusId=self.dateStatus?.id else {
            FlashMessage.showMessage(body: "لطفا وضعیت نو یا دسته دو بودن کالا را مشخص کنید.",theme: .warning)
            return
        }
        if dateStatusId == "0" {
            input.isNew=true
        } else {
            input.isNew=false
        }
        
        
        guard let giftDescription=self.descriptionTextView.text , giftDescription != "" else {
            FlashMessage.showMessage(body: "لطفا توضیحات کالا را وارد نمایید",theme: .warning)
            return
        }
        input.description=giftDescription
        
        guard let price=Int(self.priceTextView.text ?? "") else {
            FlashMessage.showMessage(body: "لطفا قیمت کالا را وارد نمایید",theme: .warning)
            return
        }
        input.price=price
        
        
        if giftHasNewAddress {
            
            let addressObject=getAddress()
            guard let address=addressObject.address else {
                FlashMessage.showMessage(body: "لطفا محل کالا را انتخاب نمایید",theme: .warning)
                return
            }
            guard let cityId=addressObject.cityId else {
                FlashMessage.showMessage(body: "لطفا محل کالا را انتخاب نمایید",theme: .warning)
                return
            }
            
            let regionId=addressObject.regionId
            
            input.address=address
            input.cityId=cityId
            input.regionId=(regionId ?? 0)
            
        } else {
            
            input.address=self.editedGiftOriginalAddress.text
            input.cityId=self.editedGiftOriginalCityId
            input.regionId=self.editedGiftOriginalRegionId
            
        }
        
        
        
        let giftImages=getGiftImages()
        input.giftImages=giftImages
        
        
        var url=APIURLs.Gift
        
        if let giftId=giftId {
            url+="/\(giftId)"
        }
        
        APICall.request(url: url, httpMethod: httpMethod, input: input) { (data, response, error) in
            
            responseHandler?()
            
//            print("Register Reply")
//            APICall.printData(data: data)
            
            if let response = response as? HTTPURLResponse {
                print((response).statusCode)
                
                if response.statusCode >= 200 && response.statusCode <= 300 {
                    
                    complitionHandler?()
                    
                }
            }
        }
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
    
    func getAddress()->(address:String?,cityId:Int?,regionId:Int?) {
        guard let cityId=self.places.first?.id , let cityName=self.places.first?.name else {
            return (nil,nil,nil)
        }
        
        var regionId:Int?
        if places.count>1 {
            regionId=places[1].id
        }
        
        var address=cityName
        for i in 1..<places.count {
            if let name=places[i].name {
                address += " " + name
            }
        }
        
        return(address,cityId,regionId)
        
    }
    
    
    
    
    
    @objc func clearBarBtnAction(){
        self.clearAllInput()
    }
    @objc func saveBarBtnAction(){
        self.saveDraft()
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
        self.giftHasNewAddress=true
        self.configAddressViews()
        
        let controller=OptionsListViewController(nibName: "OptionsListViewController", bundle: Bundle(for:OptionsListViewController.self))
        controller.option = OptionsListViewController.Option.city(showRegion: true)
        controller.completionHandler={ [weak self] (id,name) in
            let place=Place(id: Int(id ?? ""), name: name)
            self?.places.append(place)
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
        label.font=AppFont.getRegularFont(size: 17)
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
        places=[]
    }
    
    @IBAction func categoryBtnClicked(_ sender: Any) {
        
        let controller=OptionsListViewController(nibName: "OptionsListViewController", bundle: Bundle(for:OptionsListViewController.self))
        controller.option = OptionsListViewController.Option.category
        controller.completionHandler={ [weak self] (id,name) in
            self?.categoryBtn.setTitle(name, for: .normal)
            self?.category=Category(id: id, title: name)
        }
        let nc=UINavigationController(rootViewController: controller)
        self.present(nc, animated: true, completion: nil)
    }
    
    @IBAction func dateStatusBtnAction(_ sender: Any) {
        let controller=OptionsListViewController(nibName: "OptionsListViewController", bundle: Bundle(for:OptionsListViewController.self))
        controller.option = OptionsListViewController.Option.dateStatus
        controller.completionHandler={ [weak self] (id,name) in
            self?.dateStatusBtn.setTitle(name, for: .normal)
            self?.dateStatus=DateStatus(id: id, title: name)
        }
        let nc=UINavigationController(rootViewController: controller)
        self.present(nc, animated: true, completion: nil)
    }
    
    @IBAction func uploadBtnClicked(_ sender: Any) {
        let actionController = SkypeActionController()
        
        actionController.addAction(Action("دوربین", style: .default, handler: { action in
            
            self.imagePicker.allowsEditing = false
            self.imagePicker.sourceType = .camera
            self.imagePicker.delegate = self
            
            self.present(self.imagePicker, animated: true, completion: nil)
            
        }))
        
        actionController.addAction(Action("گالری تصاویر", style: .default, handler: { action in
            
            self.imagePicker.allowsEditing = false
            self.imagePicker.sourceType = .photoLibrary
            self.imagePicker.delegate = self
    
            self.present(self.imagePicker, animated: true, completion: nil)
            
        }))
        
        present(actionController, animated: true, completion: nil)


    }
    
    override func viewWillAppear(_ animated: Bool) {
        NavigationBarStyle.setDefaultStyle(navigationC: navigationController)
        self.navigationItem.title="ثبت هدیه"
        
    }
    
   
    
}


