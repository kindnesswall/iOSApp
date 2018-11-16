//
//  ActivationEnterPhoneViewController.swift
//  iptv
//
//  Created by Hamed.Gh on 8/1/1396 AP.
//  Copyright © 1396 aseman. All rights reserved.
//

import UIKit

class ActivationEnterPhoneViewController: UIViewController {
    
    let userDefault=UserDefaults.standard
    
    @IBOutlet weak var guideLabel: UILabel!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var registerBtn: UIButton!
    @IBOutlet weak var loading: UIActivityIndicatorView!
    
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
        
        self.phoneNumberTextField.keyboardType = UIKeyboardType.numberPad
        
        if let phoneNumber = userDefault.string(forKey: AppConstants.PHONE_NUMBER) {
            phoneNumberTextField.text =  phoneNumber
        }
        
        setNavBar()
//        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LoginViewController.dismissKeyboard))
//        view.addGestureRecognizer(tap)
        
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
        self.registerBtn.setTitle(AppLiteral.sendingActivationCode, for: .normal)
        self.guideLabel.text=AppLiteralForMessages.guideOfSendingActivationCode
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
    
    func customizeUIElements() {
        
        self.phoneNumberTextField.backgroundColor=UIColor.clear
        
        let uiFont = UIFont(name: "IRANSansMobile-Medium", size: 13)
        let attr = [NSAttributedString.Key.font : uiFont!,NSAttributedString.Key.foregroundColor: UIColor.gray]
        
        let nsAttr = NSAttributedString(string:"", attributes: attr)
        
        self.phoneNumberTextField.attributedPlaceholder = nsAttr
        
        self.registerBtn.backgroundColor=AppColor.tintColor
        
    }
    
    @IBAction func registerBtnClick(_ sender: Any) {
        let mobile:String = phoneNumberTextField.text ?? ""
        if !mobile.starts(with: "09") || mobile.count != 11 || !mobile.isNumber{
            FlashMessage.showMessage(body: AppLiteralForMessages.phoneNumberIncorrectError, theme: .error)
            return
        }
        
        userDefault.set(mobile, forKey: AppConstants.PHONE_NUMBER)
        userDefault.synchronize()
        
        phoneNumberTextField.isUserInteractionEnabled = false
        
        registerBtn.setTitle("", for: [])
        loading.startAnimating()
        
        ApiMethods.register(telephone: mobile) { (data, response, error) in
            
            self.registerBtn.setTitle(AppLiteral.sendingActivationCode, for: [])
            self.loading.stopAnimating()
            
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
//            inputJson: input
//        ) { (data, response, error) in
//            
//            self.registerBtn.setTitle("ارسال کد فعال‌سازی", for: [])
//            self.loading.stopAnimating()
//            
//            APIRequest.logReply(data: data)
//            
//            self.phoneNumberTextField.isUserInteractionEnabled = true
//            
//            if let reply=APIRequest.readJsonData(data: data, outpuType: RequestActivateUserOutput.self) {
//                if let status=reply.status,status==APIStatus.DONE {
//                    
//                    switch status{
//                    case APIStatus.DONE:
//                        
//                        let controller=ActivationEnterVerifyCodeViewController(nibName: "ActivationEnterVerifyCodeViewController", bundle:
//                            Bundle(for: ActivationEnterVerifyCodeViewController.self))
//                        if let requestedId = reply.request_id {
//                            controller.requestId = String(describing: requestedId)
//                        }
//                        controller.setCloseComplition(closeComplition: self.closeComplition)
//                        if mobile != "" {
//                            controller.mobile=mobile
//                        }
//                        self.navigationController?.pushViewController(controller, animated: true)
//                        
//                    case APIStatus.INVALID_USER_OR_PASS:
//                        FlashMessage.showMessage(body: "لطفا نام کاربری و رمز عبور خود را وارد نمایید.",theme: .warning)
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
    
}
