//
//  ProfileViewController.swift
//  app
//
//  Created by Hamed Ghadirian on 19.05.19.
//  Copyright © 2019 Hamed.Gh. All rights reserved.
//

import UIKit
import Kingfisher
import KeychainSwift
import XLActionController

class ProfileViewController: UIViewController {

    var closeComplition:(()->Void)?
    var username:String?
    let imagePicker = UIImagePickerController()
    var vm:ProfileViewModel?

    lazy var usernameBtnLoader:UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.hidesWhenStopped = true
        activityIndicator.color = UIColor.lightGray
        self.usernameBtn.addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        return activityIndicator
    }()
    
    @IBOutlet weak var uploadProgressView: UIView!
    @IBOutlet weak var uploadProgressLbl: UILabel!
    @IBAction func cancelUploadBtn(_ sender: Any) {
        
    }
    
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var uploadView: UIView!
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var phoneLabel: UILabel!
    
    @IBOutlet weak var usernameBtn: UIButton!
    @IBAction func onUsernameBtnClicked(_ sender: Any) {
        
        usernameBtn.setImage(nil, for: .normal)
        usernameBtnLoader.startAnimating()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.usernameBtnLoader.stopAnimating()
            self.username = self.usernameTextField.text
        }
        
    }
    
    func setCloseComplition(closeComplition: (()->Void)? ) {
        self.closeComplition = closeComplition
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavBar()
        
        vm = ProfileViewModel()
        vm?.delegate = self
        getProfile()
        
        usernameBtnLoader.centerXAnchor.constraint(equalTo: self.usernameBtn.centerXAnchor).isActive = true
        usernameBtnLoader.centerYAnchor.constraint(equalTo: self.usernameBtn.centerYAnchor).isActive = true
        
        usernameTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.selectImage(_:)))
        uploadView.addGestureRecognizer(tap)
        setDefaultViews()
    }
    
    func getProfile() {
        vm?.getProfile(completion: { [weak self](result) in
            guard let self = self else {return}
            switch result {
            case .failure(_):
                let alert = UIAlertController(
                    title:LocalizationSystem.getStr(forKey: LanguageKeys.requestfail_dialog_title),
                    message: LocalizationSystem.getStr(forKey: LanguageKeys.requestfail_dialog_text),
                    preferredStyle: UIAlertController.Style.alert)
                
                alert.addAction(
                    UIAlertAction(
                        title: LocalizationSystem.getStr(forKey: LanguageKeys.tryAgain),
                        style: UIAlertAction.Style.default, handler: { [weak self] (action) in
                    self?.getProfile()
                }))
                
                alert.addAction(
                    UIAlertAction(
                        title: LocalizationSystem.getStr(forKey: LanguageKeys.closeThisPage),
                        style: UIAlertAction.Style.default, handler: { [weak self] (action) in
                            self?.dismiss(animated: true, completion: nil)
                    }))
                
                self.present(alert, animated: true, completion: nil)
                
            case .success(let myProfile):
                DispatchQueue.main.async {
                    self.username = myProfile.name
                    self.phoneLabel.text = UserDefaults.standard.string(forKey: AppConst.UserDefaults.PHONE_NUMBER)
                    self.usernameTextField.text = myProfile.name
                    if let path = myProfile.image {
                        self.avatarImageView.kf.setImage(with: URL(string: path), placeholder: UIImage(named: "blank_avatar"))
                    }
                }
            }
        })
    }
    
    func setDefaultViews() {
        uploadProgressView.isHidden = true
        uploadView.isHidden = false
    }
    
    @objc func selectImage(_ sender: UITapGestureRecognizer){
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

    @objc func textFieldDidChange(_ textField: UITextField) {
        if username != textField.text {
            usernameBtn.isHidden = false
            usernameBtn.setImage(UIImage(named: "ic_check_grey"), for: .normal)
            
        }else {
            usernameBtn.isHidden = true
        }
    }
    
    func setNavBar(){
        self.navigationItem.title=LocalizationSystem.getStr(forKey: LanguageKeys.profile)
        
        self.navigationItem.removeDefaultBackBtn()
        
        self.navigationItem.setRightBtn(target: self, action: #selector(self.exitBtnAction), text: "", font: AppConst.Resource.Font.getIcomoonFont(size: 24))
    }
    
    @objc func exitBtnAction(){
        self.closeComplition?()
        self.dismiss(animated: true, completion: nil)
    }
}
