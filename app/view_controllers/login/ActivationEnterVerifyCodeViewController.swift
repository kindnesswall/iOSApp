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
    let keychain = KeychainSwift()
    
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
            tipLabel.text = LocalizationSystem.getStr(forKey: LanguageKeys.guideOfRegitering_part1) + AppLanguage.getNumberString(number: phoneNumber) + LocalizationSystem.getStr(forKey: LanguageKeys.guideOfRegitering_part2)
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
        
        self.navigationItem.title=LocalizationSystem.getStr(forKey: LanguageKeys.login)
        
        self.registerBtn.setTitle(LocalizationSystem.getStr(forKey: LanguageKeys.registeringActivationCode), for: .normal)
        self.sendAgainBtn.setTitle(LocalizationSystem.getStr(forKey: LanguageKeys.resendActivationCode), for: .normal)
        self.returnBtn.setTitle(LocalizationSystem.getStr(forKey: LanguageKeys.back), for: .normal)
        
        self.setTipLabel()
    }
    
    func setNavBar(){
        //        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.navigationItem.title=LocalizationSystem.getStr(forKey: LanguageKeys.login)
        self.navigationItem.removeDefaultBackBtn()
        self.navigationItem.setRightBtn(target: self, action: #selector(self.exitBtnAction), text: "", font: AppFont.getIcomoonFont(size: 24))
    }
    
    @objc func exitBtnAction(){
        self.closeComplition?()
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func registerBtnClick(_ sender: Any) {
        
        let activationCode:String = verifyCodeTextField.text?.castNumberToEnglish() ?? ""
        
        if activationCode.count <= 0 {
            FlashMessage.showMessage(body: LocalizationSystem.getStr(forKey: LanguageKeys.activationCodeError),theme: .warning)
            return
        }
        
        if activationCode.count < 4 {
            FlashMessage.showMessage(body: LocalizationSystem.getStr(forKey: LanguageKeys.activationCodeIncorrectError),theme: .warning)
            return
        }
        
        guard let mobile = userDefault.string(forKey: AppConstants.PHONE_NUMBER) else {
            FlashMessage.showMessage(body: LocalizationSystem.getStr(forKey: LanguageKeys.phoneNumberTryAgainError), theme: .error)
            return
        }
        
        registerBtn.setTitle("", for: [])
        registerLoading.startAnimating()
        
        ApiMethods.login(mobile: mobile, verificationCode: activationCode) { [weak self] (data, urlResponse, error) in
            
            DispatchQueue.main.async {
                self?.registerBtn.setTitle(LocalizationSystem.getStr(forKey: LanguageKeys.registeringActivationCode), for: [])
                self?.registerLoading.stopAnimating()
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
                    FlashMessage.showMessage(body: LocalizationSystem.getStr(forKey: LanguageKeys.activationCodeIncorrectError),theme: .warning)
                    return
                }
                
                self?.keychain.set(mobile, forKey: AppConstants.PHONE_NUMBER)
                
                if let userId = reply.userId {
//                    self.userDefault.set(userId, forKey: AppConstants.USER_ID)
                    self?.keychain.set(userId, forKey: AppConstants.USER_ID)
                }
                if let userName = reply.userName {
//                    self.userDefault.set(userName, forKey: AppConstants.USERNAME)
                    self?.keychain.set(userName, forKey: AppConstants.USER_NAME)
                }
                if let token = reply.access_token {
//                    self.userDefault.set(
//                        AppConstants.BEARER + " " + token, forKey: AppConstants.Authorization)
                    
                    self?.keychain.set(AppConstants.BEARER + " " + token, forKey: AppConstants.Authorization)
                }
                
                self?.dismiss(animated: true, completion: {
                    
                    self?.submitComplition?("")
                    
                })
            }
        }
    }
    
    @IBAction func sendAgainBtnClick(_ sender: Any) {
        
        self.sendAgainBtn.setTitle("", for: [])
        self.resendLoading.startAnimating()
        
        guard let mobile = userDefault.string(forKey: AppConstants.PHONE_NUMBER) else {
            FlashMessage.showMessage(body: LocalizationSystem.getStr(forKey: LanguageKeys.phoneNumberTryAgainError), theme: .error)
            self.sendAgainBtn.setTitle(LocalizationSystem.getStr(forKey: LanguageKeys.resendActivationCode), for: [])
            self.resendLoading.stopAnimating()
            return
        }
        
        ApiMethods.register(telephone: mobile) { (data, response, error) in
            
            self.sendAgainBtn.setTitle(LocalizationSystem.getStr(forKey: LanguageKeys.resendActivationCode), for: [])
            self.resendLoading.stopAnimating()
            
            if let response = response as? HTTPURLResponse {
                if response.statusCode < 200 && response.statusCode >= 300 {
                    FlashMessage.showMessage(body: LocalizationSystem.getStr(forKey: LanguageKeys.activationCodeSendSuccessfully), theme: .success)
                    return
                }else{
                    FlashMessage.showMessage(body: LocalizationSystem.getStr(forKey: LanguageKeys.activationCodeTryAgainOneMinuteLater), theme: .error)
                    return
                }
            }
            guard error == nil else {
                FlashMessage.showMessage(body: LocalizationSystem.getStr(forKey: LanguageKeys.weEncounterErrorTryAgain), theme: .error)
                print("Get error register")
                return
            }
            
        }
        
    }
    
    @IBAction func returnBtnClick(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    func customizeUIElements() {
        self.verifyCodeTextField.backgroundColor=UIColor.clear
        self.verifyCodeTextField.attributedPlaceholder=NSAttributedString(string:LocalizationSystem.getStr(forKey: LanguageKeys.activationCode), attributes: [NSAttributedString.Key.font : AppFont.getLightFont(size: 13),NSAttributedString.Key.foregroundColor: UIColor.gray])
        
        self.registerBtn.backgroundColor=AppColor.tintColor
        
        self.returnBtn.setTitleColor(AppColor.tintColor, for: UIControl.State())
        self.sendAgainBtn.setTitleColor(AppColor.tintColor, for: UIControl.State())

        UIFunctions.setBordersStyle(view: self.registerBtn, radius: 10, width: 1, color: AppColor.tintColor)
        
        UIFunctions.setBordersStyle(view: self.returnBtn, radius: 10, width: 1, color: AppColor.tintColor)
        
        UIFunctions.setBordersStyle(view: self.sendAgainBtn, radius: 10, width: 1, color: AppColor.tintColor)
    }
    
}
