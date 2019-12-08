//
//  ActivationEnterPhoneViewController.swift
//  iptv
//
//  Created by Hamed.Gh on 8/1/1396 AP.
//  Copyright © 1396 aseman. All rights reserved.
//

import UIKit

class LoginRegisterViewController: UIViewController {

    let userDefaultService = UserDefaultService()
    @IBOutlet weak var countryCodeInput: ShakingTextField!
    @IBOutlet weak var guideLabel: UILabel!
    @IBOutlet weak var phoneNumberTextField: ShakingTextField!
    @IBOutlet weak var registerBtn: UIButton!
    @IBOutlet weak var loading: UIActivityIndicatorView!

    var viewModel: LoginRegisterViewModelProtocol?

    var mobile = ""
    var countryCode = ""
    var mobileWithCode: String {
        return "+\(countryCode)\(mobile)"
    }

    var closeComplition:(() -> Void)?

    func setCloseComplition(closeComplition: (() -> Void)? ) {
        self.closeComplition = closeComplition
    }

    var submitComplition: ((String) -> Void)?

    func setSubmitComplition(submitComplition: ((String) -> Void)?) {
        self.submitComplition=submitComplition
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let country = AppCountry.getCurrent

        if country == AppConst.Country.iran {
            self.viewModel = LoginRegisterViewModel()
        } else {
            self.viewModel = FirebaseLoginRegisterViewModel()
        }

        customizeUIElements()

        self.phoneNumberTextField.keyboardType = UIKeyboardType.numberPad

        if let phoneNumber = userDefaultService.getString(.phoneNumber) {
            phoneNumberTextField.text =  AppLanguage.getNumberString(number: phoneNumber)
        }

        if let countryCode = AppCountry.getPhoneCode() {
            self.countryCodeInput.text = AppLanguage.getNumberString(number: countryCode)
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

    func setAllTextsInView() {
        self.navigationItem.title=LanguageKeys.login.localizedString
        self.registerBtn.setTitle(LanguageKeys.sendingActivationCode.localizedString, for: .normal)
        self.guideLabel.text=LanguageKeys.guideOfSendingActivationCode.localizedString
    }

    func setNavBar() {
//        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.navigationItem.title=LanguageKeys.login.localizedString
        self.navigationItem.removeDefaultBackBtn()
        self.navigationItem.setRightBtn(target: self, action: #selector(self.exitBtnAction), text: "", font: AppFont.getIcomoonFont(size: 24))
    }

    @objc func exitBtnAction() {
        self.closeComplition?()
        self.dismiss(animated: true, completion: nil)
    }

    func customizeUIElements() {

        self.phoneNumberTextField.backgroundColor=UIColor.clear

        let uiFont = UIFont(name: "IRANSansMobile-Medium", size: 13)
        let attr = [NSAttributedString.Key.font: uiFont!, NSAttributedString.Key.foregroundColor: UIColor.gray]

        let nsAttr = NSAttributedString(string: "", attributes: attr)

        self.phoneNumberTextField.attributedPlaceholder = nsAttr

        self.registerBtn.backgroundColor=AppColor.Tint

    }

    @IBAction func registerBtnClick(_ sender: Any) {
        mobile = phoneNumberTextField.text?.castNumberToEnglish() ?? ""
        if !mobile.starts(with: "9") || mobile.count != 10 || !mobile.isNumber {
            FlashMessage.showMessage(body: LanguageKeys.phoneNumberIncorrectError.localizedString, theme: .error)
            self.phoneNumberTextField.shake()
            return
        }

        userDefaultService.set(.phoneNumber, value: mobile)

        countryCode = countryCodeInput.text?.castNumberToEnglish() ?? ""
        guard countryCode != "" else {
            FlashMessage.showMessage(body: LanguageKeys.phoneNumberIncorrectError.localizedString, theme: .error)
            countryCodeInput.shake()
            return
        }

        phoneNumberTextField.isUserInteractionEnabled = false

        registerBtn.setTitle("", for: [])
        loading.startAnimating()

        viewModel?.registerUser(with: mobileWithCode, handleResult: { [weak self] result in
            self?.handleResult(result)
        })

    }

    func handleResult(_ result: Result<String?>) {
        self.registerBtn.setTitle(LanguageKeys.sendingActivationCode.localizedString, for: [])
        self.loading.stopAnimating()

        switch result {
        case .failure(let error):
            var bodyString: String = "Error"
            switch error {
            case .serverError:
                bodyString = LanguageKeys.activationCodeTryAgainOneMinuteLater.localizedString
            default:
                bodyString = LanguageKeys.weEncounterErrorTryAgain.localizedString
            }
            FlashMessage.showMessage(body: bodyString, theme: .error)

        case .success(let verificationId):
            let controller=VerificationCodeViewController()
            controller.viewModel = viewModel
            controller.mobileWithCode = mobileWithCode
            controller.verificationId = verificationId
            controller.setCloseComplition(closeComplition: self.closeComplition)
            controller.setSubmitComplition(submitComplition: self.submitComplition)
            self.navigationController?.pushViewController(controller, animated: true)

        }
    }
}
