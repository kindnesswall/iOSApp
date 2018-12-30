//
//  LoginRegisterVC.swift
//  SwiftMessenger
//
//  Created by Hamed.Gh on 12/22/18.
//  Copyright © 2018 MacBook Pro. All rights reserved.
//

import UIKit
import Firebase

class LoginRegisterVC: UIViewController,UITextFieldDelegate {
    
    var inputContainerViewHeightConstraint: NSLayoutConstraint?
    var passwordHeightConstraint: NSLayoutConstraint?
    var emailHeightConstraint: NSLayoutConstraint?
    var nameHeightConstraint: NSLayoutConstraint?
    
//    var messagesController: MessageVC?

    let inputContainerView:UIView = {
        var customView = UIView()
        customView.backgroundColor = .white
        
        customView.layer.cornerRadius = 5
        customView.layer.masksToBounds = true
        
        customView.translatesAutoresizingMaskIntoConstraints = false
        return customView
    }()
    
    
    let loginRegisterBtn:UIButton = {
        var btn = UIButton()
        btn.backgroundColor = UIColor(red: 80, green: 101, blue: 161)
        
        btn.setTitle("Register", for: .normal)
        btn.titleLabel?.font = .boldSystemFont(ofSize: 16)
        
        btn.layer.cornerRadius = 5
        btn.layer.masksToBounds = true
        
        btn.translatesAutoresizingMaskIntoConstraints = false
        
        btn.addTarget(self, action: #selector(handleLoginRegisterBtnClicked), for: .touchUpInside)
        
        return btn
    }()
    
    let nameTF:UITextField = {
        var tf = UITextField()
        tf.backgroundColor = .white
        tf.placeholder = "Name"
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    let nameSeparatorView:UIView = {
        var customView = UIView()
        customView.backgroundColor = UIColor(red: 220, green: 220, blue: 220)
        customView.translatesAutoresizingMaskIntoConstraints = false
        return customView
    }()
    
    let emailTF:UITextField = {
        var tf = UITextField()
        tf.backgroundColor = .white
        tf.placeholder = "Email"
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    let emailSeparatorView:UIView = {
        var customView = UIView()
        customView.backgroundColor = UIColor(red: 220, green: 220, blue: 220)
        customView.translatesAutoresizingMaskIntoConstraints = false
        return customView
    }()
    
    lazy var passwordTF:UITextField = {
        var tf = UITextField()
        tf.backgroundColor = .white
        tf.placeholder = "Password"
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.isSecureTextEntry = true
        tf.delegate = self
        return tf
    }()
    
    lazy var profileImageView:UIImageView = {
        let iv = UIImageView()
//        iv.image = UIImage(named: "avatar")
//        iv.contentMode = .scaleAspectFill
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.isUserInteractionEnabled = true
        iv.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleImageTap)))
        
        return iv
    }()
    
    let loginRegisterSegmentControl:UISegmentedControl = {
        let sc = UISegmentedControl(items: ["Login","Register"])
        sc.tintColor = .white
        sc.selectedSegmentIndex = 1
        sc.translatesAutoresizingMaskIntoConstraints = false
        
        sc.addTarget(self, action: #selector(handleSegmentedControlChange), for: .valueChanged)
        return sc
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 61, green: 91, blue: 151)
        
        view.addSubview(inputContainerView)
        view.addSubview(loginRegisterBtn)
        view.addSubview(profileImageView)
        view.addSubview(loginRegisterSegmentControl)
    
        setupViews()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        handleLoginRegisterBtnClicked()
        return true
    }
}



