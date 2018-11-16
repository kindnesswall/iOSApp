//
//  ActivationEnterVerifyCodeViewController.swift
//  iptv
//
//  Created by Hamed.Gh on 8/1/1396 AP.
//  Copyright © 1396 aseman. All rights reserved.
//

import UIKit
import KeychainSwift

class ActivationEnterVerifyCodeViewController: UIViewController {

    var requestId:String!
    var session:URLSession?
    var task:URLSessionDataTask?
    let keychain = KeychainSwift()
    
    var mobile:String?
    
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
        
        setNavBar()
        
        self.verifyCodeTextField.keyboardType = UIKeyboardType.numberPad
        
        self.setTipLabel()
        
//        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LoginViewController.dismissKeyboard))
//        view.addGestureRecognizer(tap)
        
    }
    
    func setTipLabel(){
        if let phoneNumber = userDefault.string(forKey: AppConstants.PHONE_NUMBER) {
            tipLabel.text = AppLiteralForMessages.guideOfRegitering_part1 + AppLanguage.getNumberString(number: phoneNumber) + AppLiteralForMessages.guideOfRegitering_part2
        }
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.setDefaultStyle()
        self.setAllTextsInView()
    }
    
    func setAllTextsInView(){
        
        self.navigationItem.title=AppLiteral.login
        
        self.registerBtn.setTitle(AppLiteral.registeringActivationCode, for: .normal)
        self.sendAgainBtn.setTitle(AppLiteral.resendingActivationCode, for: .normal)
        self.returnBtn.setTitle(AppLiteral.back, for: .normal)
        
        self.setTipLabel()
    }
    
    func setNavBar(){
        //        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.navigationItem.title=AppLiteral.login
        self.navigationItem.removeDefaultBackBtn()
        self.navigationItem.setRightBtn(target: self, action: #selector(self.exitBtnAction), text: "", font: AppFont.getIcomoonFont(size: 24))
    }
    
    @objc func exitBtnAction(){
        self.closeComplition?()
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func registerBtnClick(_ sender: Any) {
        
        let activationCode:String = verifyCodeTextField.text!
        
        if activationCode.count <= 0 {
            FlashMessage.showMessage(body: AppLiteralForMessages.activationCodeError,theme: .warning)
            return
        }
        
        if activationCode.count < 4 {
            FlashMessage.showMessage(body: AppLiteralForMessages.activationCodeIncorrectError,theme: .warning)
            return
        }
        
        guard let mobile = userDefault.string(forKey: AppConstants.PHONE_NUMBER) else {
            FlashMessage.showMessage(body: AppLiteralForMessages.phoneNumberTryAgainError, theme: .error)
            return
        }
        
        registerBtn.setTitle("", for: [])
        registerLoading.startAnimating()
        
        ApiMethods.login(mobile: mobile, verificationCode: activationCode) { (data, urlResponse, error) in
            
            DispatchQueue.main.async {
                self.registerBtn.setTitle(AppLiteral.registeringActivationCode, for: [])
                self.registerLoading.stopAnimating()
            }
            
            if let response = urlResponse as? HTTPURLResponse {
                if response.statusCode < 200 && response.statusCode >= 300 {
                    return
                }
            }
            guard error == nil else {
                print("Get error register")
                return
            }
            
            APIRequest.logReply(data: data)

            if let reply=APIRequest.readJsonData(data: data, outputType: TokenOutput.self) {
                
                if let error = reply.error , error == TokenOutputError.invalid_grant.rawValue {
                    FlashMessage.showMessage(body: AppLiteralForMessages.activationCodeIncorrectError,theme: .warning)
                    return
                }
                
                if let userId = reply.userId {
//                    self.userDefault.set(userId, forKey: AppConstants.USER_ID)
                    self.keychain.set(userId, forKey: AppConstants.USER_ID)
                }
                if let userName = reply.userName {
//                    self.userDefault.set(userName, forKey: AppConstants.USERNAME)
                    self.keychain.set(userName, forKey: AppConstants.USER_NAME)
                }
                if let token = reply.access_token {
//                    self.userDefault.set(
//                        AppConstants.BEARER + " " + token, forKey: AppConstants.Authorization)
                    
                    self.keychain.set(AppConstants.BEARER + " " + token, forKey: AppConstants.Authorization)
                }
                
                self.dismiss(animated: true, completion: {
                    
                    self.submitComplition?("")
                    
                })
                
            }
            
        }
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
        
        self.sendAgainBtn.setTitle("", for: [])
        self.resendLoading.startAnimating()
        
        guard let mobile = userDefault.string(forKey: AppConstants.PHONE_NUMBER) else {
            FlashMessage.showMessage(body: AppLiteralForMessages.phoneNumberTryAgainError, theme: .error)
            return
        }
        
        ApiMethods.register(telephone: mobile) { (data, response, error) in
            
            self.sendAgainBtn.setTitle(AppLiteral.resendingActivationCode, for: [])
            self.resendLoading.stopAnimating()
            
            if let response = response as? HTTPURLResponse {
                if response.statusCode < 200 && response.statusCode >= 300 {
                    return
                }
            }
            guard error == nil else {
                print("Get error register")
                return
            }
            
            let controller=ActivationEnterVerifyCodeViewController(nibName: "ActivationEnterVerifyCodeViewController", bundle:
                Bundle(for: ActivationEnterVerifyCodeViewController.self))
            
            controller.setCloseComplition(closeComplition: self.closeComplition)
            controller.setSubmitComplition(submitComplition: self.submitComplition)
            
            if mobile != "" {
                controller.mobile=mobile
            }
            self.navigationController?.pushViewController(controller, animated: true)
            
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
    
    
    func customizeUIElements() {
        self.verifyCodeTextField.backgroundColor=UIColor.clear
        self.verifyCodeTextField.attributedPlaceholder=NSAttributedString(string:AppLiteral.activationCode, attributes: [NSAttributedString.Key.font : AppFont.getLightFont(size: 13),NSAttributedString.Key.foregroundColor: UIColor.gray])
        
        self.registerBtn.backgroundColor=AppColor.tintColor
        
        self.returnBtn.setTitleColor(AppColor.tintColor, for: UIControl.State())
        self.sendAgainBtn.setTitleColor(AppColor.tintColor, for: UIControl.State())

        UIFunctions.setBordersStyle(view: self.registerBtn, radius: 10, width: 1, color: AppColor.tintColor)
        
        UIFunctions.setBordersStyle(view: self.returnBtn, radius: 10, width: 1, color: AppColor.tintColor)
        
        UIFunctions.setBordersStyle(view: self.sendAgainBtn, radius: 10, width: 1, color: AppColor.tintColor)
    }
    
}
