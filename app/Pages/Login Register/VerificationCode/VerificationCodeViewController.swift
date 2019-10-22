//
//  ActivationEnterVerifyCodeViewController.swift
//  iptv
//
//  Created by Hamed.Gh on 8/1/1396 AP.
//  Copyright © 1396 aseman. All rights reserved.
//

import UIKit

class VerificationCodeViewController: UIViewController {

    var requestId:String!
    var session:URLSession?
    lazy var apiRequest = ApiRequest(HTTPLayer())

    let userDefault = UserDefaults.standard
    
    @IBOutlet weak var verifyCodeTextField: ShakingTextField!
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
        if let phoneNumber = userDefault.string(forKey: AppConst.UserDefaults.PHONE_NUMBER) {
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
        self.navigationItem.setRightBtn(target: self, action: #selector(self.exitBtnAction), text: "", font: AppConst.Resource.Font.getIcomoonFont(size: 24))
    }
    
    @objc func exitBtnAction(){
        self.closeComplition?()
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func registerBtnClick(_ sender: Any) {
        
        let activationCode:String = verifyCodeTextField.text?.castNumberToEnglish() ?? ""
        
        if activationCode.count <= 0 {
            FlashMessage.showMessage(body: LocalizationSystem.getStr(forKey: LanguageKeys.activationCodeError),theme: .warning)
            self.verifyCodeTextField.shake()
            return
        }
        
        if activationCode.count < 5 {
            FlashMessage.showMessage(body: LocalizationSystem.getStr(forKey: LanguageKeys.activationCodeIncorrectError),theme: .warning)
            self.verifyCodeTextField.shake()
            return
        }
        
        guard let mobile = userDefault.string(forKey: AppConst.UserDefaults.PHONE_NUMBER) else {
            FlashMessage.showMessage(body: LocalizationSystem.getStr(forKey: LanguageKeys.phoneNumberTryAgainError), theme: .error)
            return
        }
        
        registerBtn.setTitle("", for: [])
        registerLoading.startAnimating()
        
        login(mobile, activationCode)
        
    }
    
    func login(_ phoneNumber: String,_ activationCode: String) {
        apiRequest.login(phoneNumber: phoneNumber, activationCode: activationCode) { [weak self] (result) in
            DispatchQueue.main.async {
                self?.handleLogin(result)
            }
        }
    }
    
    func validatePhoneNumberChange(_ phoneNumber: String,_ activationCode: String) {
        apiRequest.validatePhoneNumberChange(to: phoneNumber, with: activationCode) { [weak self] (result) in
            DispatchQueue.main.async {
                self?.handleLogin(result)
            }
        }
    }
    
    func handleLogin(_ result:Result<AuthOutput>) {
        self.registerBtn.setTitle(LocalizationSystem.getStr(forKey: LanguageKeys.registeringActivationCode), for: [])
        self.registerLoading.stopAnimating()
        
        switch(result){
        case .failure(let error):
            var msg = "Error"
            switch(error){
            case .ServerError:
                msg = LocalizationSystem.getStr(forKey: LanguageKeys.activationCodeIncorrectError)
                
                FlashMessage.showMessage(body: msg,theme: .warning)
                self.verifyCodeTextField.shake()
                
            default:
                FlashMessage.showMessage(body: LocalizationSystem.getStr(forKey: LanguageKeys.weEncounterErrorTryAgain), theme: .error)
            }
            
        case .success(let authOutput):
            if let userID = authOutput.token.userID?.description, let token = authOutput.token.token {
                AppDelegate.me().tabBarController.login(userID: userID, token: token, isAdmin: authOutput.isAdmin, isCharity: authOutput.isCharity)
            }
            
            self.dismiss(animated: true, completion: {
                UIApplication.shared.shortcutItems = [
                    UIApplicationShortcutItem(
                        type: "ir.kindnesswall.publicusers.DonateGift",
                        localizedTitle: LocalizationSystem.getStr(forKey: LanguageKeys.DonateGift),
                        localizedSubtitle: "",
                        icon: UIApplicationShortcutIcon(type: .favorite),
                        userInfo: nil)
                ]
                self.submitComplition?("")
            })
        }
    }
    
    func handleRegisterUser(_ result:Result<Void>) {
        self.sendAgainBtn.setTitle(LocalizationSystem.getStr(forKey: LanguageKeys.resendActivationCode), for: [])
        self.resendLoading.stopAnimating()
        
        switch(result){
        case .failure(let error):
            var errorMsg = "Error"
            switch(error){
            case .ServerError:
                errorMsg = LocalizationSystem.getStr(forKey: LanguageKeys.activationCodeTryAgainOneMinuteLater)
                
            default:
                errorMsg = LocalizationSystem.getStr(forKey: LanguageKeys.weEncounterErrorTryAgain)
            }
            FlashMessage.showMessage(body: errorMsg, theme: .error)

        case .success(_):
            let msg = LocalizationSystem.getStr(forKey: LanguageKeys.activationCodeSendSuccessfully)
            FlashMessage.showMessage(body: msg, theme: .success)
            
        }
    }
    
    @IBAction func sendAgainBtnClick(_ sender: Any) {
        
        self.sendAgainBtn.setTitle("", for: [])
        self.resendLoading.startAnimating()
        
        guard let mobile = userDefault.string(forKey: AppConst.UserDefaults.PHONE_NUMBER) else {
            FlashMessage.showMessage(body: LocalizationSystem.getStr(forKey: LanguageKeys.phoneNumberTryAgainError), theme: .error)
            self.sendAgainBtn.setTitle(LocalizationSystem.getStr(forKey: LanguageKeys.resendActivationCode), for: [])
            self.resendLoading.stopAnimating()
            return
        }
        
        apiRequest.registerUser(phoneNumber: mobile) { [weak self] (result) in
            DispatchQueue.main.async {
                self?.handleRegisterUser(result)
            }
        }
    }
    
    @IBAction func returnBtnClick(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    func customizeUIElements() {
        self.verifyCodeTextField.backgroundColor=UIColor.clear
        self.verifyCodeTextField.attributedPlaceholder=NSAttributedString(string:LocalizationSystem.getStr(forKey: LanguageKeys.activationCode), attributes: [NSAttributedString.Key.font : AppConst.Resource.Font.getLightFont(size: 13),NSAttributedString.Key.foregroundColor: UIColor.gray])
        
        self.registerBtn.backgroundColor=AppConst.Resource.Color.Tint
        
        self.returnBtn.setTitleColor(AppConst.Resource.Color.Tint, for: UIControl.State())
        self.sendAgainBtn.setTitleColor(AppConst.Resource.Color.Tint, for: UIControl.State())

        UIFunctions.setBordersStyle(view: self.registerBtn, radius: 10, width: 1, color: AppConst.Resource.Color.Tint)
        
        UIFunctions.setBordersStyle(view: self.returnBtn, radius: 10, width: 1, color: AppConst.Resource.Color.Tint)
        
        UIFunctions.setBordersStyle(view: self.sendAgainBtn, radius: 10, width: 1, color: AppConst.Resource.Color.Tint)
    }
    
}
