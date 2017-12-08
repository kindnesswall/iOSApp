//
//  ActivationEnterVerifyCodeViewController.swift
//  iptv
//
//  Created by Hamed.Gh on 8/1/1396 AP.
//  Copyright © 1396 aseman. All rights reserved.
//

import UIKit

class ActivationEnterVerifyCodeViewController: UIViewController {

    var requestId:String!
    var session:URLSession?
    var task:URLSessionDataTask?
    
    
    var mobile:String?
    
    var part1:String = "تا لحظاتی دیگر پیامی حاوی کد فعالسازی به شماره "
    
    var part2:String = " ارسال خواهد شد. در صورتیکه کد را دریافت نکردید می توانید پس از ۱ دقیقه مجددا سعی کنید."
    
    let userDefault = UserDefaults.standard
    
    @IBOutlet weak var verifyCodeTextField: UITextField!
    @IBOutlet weak var resendLoading: UIActivityIndicatorView!
    
    @IBOutlet weak var registerBtn: UIButton!
    @IBOutlet weak var sendAgainBtn: UIButton!
    @IBOutlet weak var returnBtn: UIButton!
    
    @IBOutlet weak var tipLabel: UILabel!
    
    @IBOutlet weak var registerLoading: UIActivityIndicatorView!
    
    
    var closeComplition:(()->Void)?
    
    func setCloseComplition(closeComplition: (()->Void)? ) {
        self.closeComplition = closeComplition
    }
    
    var submitComplition:((String)->Void)?
    
    func setSubmitComplition(submitComplition:((String)->Void)?){
        self.submitComplition=submitComplition
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customizeUIElements()
        
        self.verifyCodeTextField.keyboardType = UIKeyboardType.numberPad
        
        if let phoneNumber = userDefault.string(forKey: AppConstants.PHONE_NUMBER) {
            tipLabel.text = part1 + UIFunctions.CastNumberToPersian(input: phoneNumber) + part2
        }
        
//        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LoginViewController.dismissKeyboard))
//        view.addGestureRecognizer(tap)
        
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @IBAction func registerBtnClick(_ sender: Any) {
        
        guard let requestId:String = self.requestId else{
            return
        }
        
        let activationCode:String = verifyCodeTextField.text!
        
        if activationCode.count <= 0 {
            FlashMessage.showMessage(body: "کد را وارد نمایید",theme: .warning)
            return
        }
        
        if activationCode.count < 4 {
            FlashMessage.showMessage(body: "کد وارد شده صحیح نمی باشد",theme: .warning)
            return
        }
        
        guard let _=userDefault.string(forKey: AppConstants.USER_TOKEN) else {
            return
        }
        
        registerBtn.setTitle("", for: [])
        registerLoading.startAnimating()
        
//        APIRequest.request(
//            url: APIURLs.activateUser,
//            inputJson: ["request_id":requestId,"activation_code":activationCode]
//        ) { (data, response, error) in
//
//            self.registerBtn.setTitle("ثبت کدفعالسازی", for: [])
//            self.registerLoading.stopAnimating()
//
//            APIRequest.logReply(data: data)
//
//            if let reply=APIRequest.readJsonData(data: data, outpuType: ActivateUserOutput.self) {
//                if let status=reply.status,status==APIStatus.DONE {
//
//                    if let isValid = reply.is_valid, isValid {
//
//                        self.userDefault.set(isValid, forKey: AppConstants.IS_ACTIVE)
//                        self.submitComplition?("")
//                        self.dismiss(animated: true, completion: nil)
//
//                    }else{
//                        FlashMessage.showMessage(body: "کد وارد شده صحیح نمی باشد",theme: .warning)
//                    }
//
//                }
//            }
//        }
//
        
    }
    
    @IBAction func sendAgainBtnClick(_ sender: Any) {
        let username:String = userDefault.string(forKey: AppConstants.USERNAME) ?? ""
        
        self.sendAgainBtn.setTitle("", for: [])
        self.resendLoading.startAnimating()
        
        var input:[String:String]?
        if let mobile=self.mobile {
            input=["username":username,"mobile":mobile]
        } else {
            input=["username":username]
        }
        
        
//        APIRequest.request(
//            url: APIURLs.requestActivateUser,
//            inputJson:input
//        ) { (data, response, error) in
//
//            self.sendAgainBtn.setTitle("دریافت مجدد کد فعالسازی", for: [])
//            self.resendLoading.stopAnimating()
//
//            APIRequest.logReply(data: data)
//
//            if let reply=APIRequest.readJsonData(data: data, outpuType: RequestActivateUserOutput.self) {
//                if let status=reply.status,status==APIStatus.DONE {
//
//                    switch status{
//                    case APIStatus.DONE:
//
//                        FlashMessage.showMessage(body: "کد مجدد به شماره تلفن شما ارسال گردید",theme: .warning)
//
//                        self.requestId = String(describing: reply.request_id)
//
//
//                    default:
//
//                        break
//                    }
//
//
//                }
//            }
//        }
        
        
    }
    
    @IBAction func returnBtnClick(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func closeBtnClick(_ sender: Any) {
        self.closeComplition?()
        self.dismiss(animated: true, completion: nil)
    }
    
    func customizeUIElements() {
        self.verifyCodeTextField.backgroundColor=UIColor.clear
        self.verifyCodeTextField.attributedPlaceholder=NSAttributedString(string:"کد فعالسازی", attributes: [NSAttributedStringKey.font : UIFont(name: "IranSans-Light", size: 13)!,NSAttributedStringKey.foregroundColor: UIColor.gray])
        
        self.registerBtn.backgroundColor=AppColor.tintColor
        
        self.returnBtn.setTitleColor(AppColor.tintColor, for: UIControlState())
        self.sendAgainBtn.setTitleColor(AppColor.tintColor, for: UIControlState())

        UIFunctions.setBordersStyle(view: self.registerBtn, radius: 10, width: 1, color: AppColor.tintColor)
        
        UIFunctions.setBordersStyle(view: self.returnBtn, radius: 10, width: 1, color: AppColor.tintColor)
        
        UIFunctions.setBordersStyle(view: self.sendAgainBtn, radius: 10, width: 1, color: AppColor.tintColor)
    }
    
}
