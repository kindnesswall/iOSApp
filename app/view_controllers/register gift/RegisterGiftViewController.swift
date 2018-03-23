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
    @IBOutlet weak var dateStatusBtn: UIButton!
    var dateStatus:DateStatus?
    
    @IBOutlet weak var priceTextView: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    @IBOutlet weak var registerBtn: UIButton!
    
    @IBOutlet weak var uploadedImageStack: UIStackView!
    var uploadedImageViews=[UploadImageView]()
    
    @IBOutlet weak var placesStackView: UIStackView!
    var placesLabels=[UILabel]()
    var places=[Place]()
    
    @IBOutlet var uploadBtn: UIButton!

    @IBAction func submitBtnAction(_ sender: Any) {
        
        submitGift()
        
    }
    
    
    
    @IBOutlet weak var categoryBtn: UIButton!
    var category:Category?
    
    
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGesture=UITapGestureRecognizer(target: self, action: #selector(self.tapGestureAction))
        
        contentStackView.addGestureRecognizer(tapGesture)
        
        self.configNavBar()
        
        
        // Do any additional setup after loading the view.
    }
    
    func configNavBar(){
        
        self.navigationItem.setRightBtn(target: self, action: #selector(self.clearBarBtnAction), text: "پاک کردن")
        self.navigationItem.setLeftBtn(target: self, action: #selector(self.saveBarBtnAction), text: "ذخیره کردن")
    }
    
    func submitGift(){
        guard let title=self.titleTextView.text , title != "" else {
            FlashMessage.showMessage(body: "لطفا عنوان کالا را وارد نمایید",theme: .warning)
            return
        }
        
        guard let categoryId=Int(self.category?.id ?? "") else {
            FlashMessage.showMessage(body: "لطفا دسته‌بندی کالا را انتخاب نمایید",theme: .warning)
            return
        }
        
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
        
        
        guard let giftDescription=self.descriptionTextView.text , giftDescription != "" else {
            FlashMessage.showMessage(body: "لطفا توضیحات کالا را وارد نمایید",theme: .warning)
            return
        }
        
        guard let price=Int(self.priceTextView.text ?? "") else {
            FlashMessage.showMessage(body: "لطفا قیمت کالا را وارد نمایید",theme: .warning)
            return
        }
        
        
        let giftImages=getGiftImages()
        
        let input=RegisterGiftInput()
        input.title=title
        input.address=address
        input.description=giftDescription
        input.price=price
        input.categoryId=categoryId
        input.cityId=cityId
        input.regionId=(regionId ?? -1)
        input.giftImages=giftImages
        
        
        
        self.registerBtn.isEnabled=false
        
        APICall.request(url: APIURLs.Gift, httpMethod: .POST, input: input) { (data, response, error) in
            self.registerBtn.isEnabled=true
            
            print("Register Reply")
            APICall.printData(data: data)
            
            if let response = response as? HTTPURLResponse {
                print((response).statusCode)
                
                if response.statusCode >= 200 && response.statusCode <= 300 {
                    self.clearAllInput()
                    FlashMessage.showMessage(body: "ثبت کالا با موفقیت انجام شد",theme: .success)
                    
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
        
    }
    
    
    
    @objc func clearBarBtnAction(){
        self.clearAllInput()
    }
    @objc func saveBarBtnAction(){
        
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
        let controller=OptionsListViewController(nibName: "OptionsListViewController", bundle: Bundle(for:OptionsListViewController.self))
        controller.option = OptionsListViewController.Option.place(0)
        controller.completionHandler={ [weak self] (id,name) in
            let place=Place(id: Int(id ?? ""), name: name)
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
        
        self.places.append(place)
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


