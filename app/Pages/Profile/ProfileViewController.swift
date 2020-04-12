//
//  ProfileViewController.swift
//  app
//
//  Created by Hamed Ghadirian on 19.05.19.
//  Copyright © 2019 Hamed.Gh. All rights reserved.
//

import UIKit
import Kingfisher
import XLActionController

class ProfileViewController: UIViewController {

    var closeComplition:(() -> Void)?
    var username: String?
    let imagePicker = UIImagePickerController()
    var vm: ProfileViewModel?

    lazy var usernameBtnLoader: UIActivityIndicatorView = {
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

        updateProfile {
            DispatchQueue.main.async {
                self.usernameBtnLoader.stopAnimating()
                self.username = self.usernameTextField.text
            }
        }

    }

    func setCloseComplition(closeComplition: (() -> Void)? ) {
        self.closeComplition = closeComplition
    }
    
    var coordinator: ProfileCoordinator
    init(coordinator: ProfileCoordinator) {
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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

    func updateProfile(completion: (() -> Void)?) {
        vm?.updateUser(name: usernameTextField.text, completion: { [weak self](result) in
            switch result {
            case .failure:
                self?.coordinator.showDialogFailed(closeType: .dismissPage) {
                    self?.updateProfile(completion: completion)
                }
            case .success:
                completion?()
                FlashMessage.showMessage(body: LanguageKeys.profileUpdatedSuccessfully.localizedString, theme: .success)
            }
        })
    }

    

    func getProfile() {
        vm?.getProfile(completion: { [weak self](result) in
            guard let self = self else {return}
            switch result {
            case .failure:
                self.coordinator.showDialogFailed(closeType: .dismissPage) {
                    self.getProfile()
                }
            case .success(let myProfile):
                DispatchQueue.main.async {
                    self.username = myProfile.name
                    self.phoneLabel.text = UserDefaultService().getPhoneNumber()
                    self.usernameTextField.text = myProfile.name
                    if let path = myProfile.image {
                        self.avatarImageView.kf.setImage(with: URL(string: path), placeholder: UIImage(named: AppImages.BlankAvatar))
                    }
                }
            }
        })
    }

    func setDefaultViews() {
        uploadProgressView.isHidden = true
        uploadView.isHidden = false
    }

    @objc func selectImage(_ sender: UITapGestureRecognizer) {
        let actionController = SkypeActionController()

        actionController.addAction(Action(LanguageKeys.camera.localizedString, style: .default, handler: { _ in

            self.imagePicker.allowsEditing = false
            self.imagePicker.sourceType = .camera
            self.imagePicker.delegate = self

            self.present(self.imagePicker, animated: true, completion: nil)

        }))

        actionController.addAction(Action(LanguageKeys.gallery.localizedString, style: .default, handler: { _ in

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
            usernameBtn.setImage(UIImage(named: AppImages.CheckGrey), for: .normal)

        } else {
            usernameBtn.isHidden = true
        }
    }

    func setNavBar() {
        self.navigationItem.title=LanguageKeys.profile.localizedString

        self.navigationItem.removeDefaultBackBtn()

        self.navigationItem.setRightBtn(target: self, action: #selector(self.exitBtnAction), text: "", font: AppFont.get(.icomoon, size: 24))
    }

    @objc func exitBtnAction() {
        self.closeComplition?()
        self.dismiss(animated: true, completion: nil)
    }
}
