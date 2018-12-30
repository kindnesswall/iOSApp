//
//  LoginRegisterVC+setupviews.swift
//  SwiftMessenger
//
//  Created by Hamed.Gh on 12/23/18.
//  Copyright © 2018 MacBook Pro. All rights reserved.
//

import Foundation
import UIKit

extension LoginRegisterVC {
    func setupViews() {
        setupInputContainterView()
        setupLoginRegisterBtn()
        setupProfileImageView()
        setupSegmentedControl()
    }
    
    func setupSegmentedControl() {
        loginRegisterSegmentControl.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginRegisterSegmentControl.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor, multiplier: 1).isActive = true
        loginRegisterSegmentControl.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        //        (equalTo: inputContainerView.heightAnchor, multiplier: 1/3).isActive = true
        loginRegisterSegmentControl.bottomAnchor.constraint(equalTo: inputContainerView.topAnchor, constant: -12).isActive = true
    }
    
    func setupProfileImageView() {
        profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        profileImageView.bottomAnchor.constraint(equalTo: loginRegisterSegmentControl.topAnchor, constant: -32).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 150).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 150).isActive = true
    }
    
    func setupLoginRegisterBtn(){
        loginRegisterBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginRegisterBtn.topAnchor.constraint(equalTo: inputContainerView.bottomAnchor, constant: 12).isActive = true
        loginRegisterBtn.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1, constant: -24).isActive = true
        loginRegisterBtn.heightAnchor
            .constraint(equalToConstant: 48).isActive = true
    }
    
    
    func setupInputContainterView()  {
        inputContainerView.centerXAnchor
            .constraint(equalTo: view.centerXAnchor).isActive = true
        inputContainerView.centerYAnchor
            .constraint(equalTo: view.centerYAnchor).isActive = true
        inputContainerView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1, constant: -24).isActive = true
        inputContainerViewHeightConstraint = inputContainerView.heightAnchor
            .constraint(equalToConstant: 150)
        inputContainerViewHeightConstraint?.isActive = true
        
        inputContainerView.addSubview(nameTF)
        setupNameTF()
        
        inputContainerView.addSubview(nameSeparatorView)
        setupNameSeparatorView()
        
        inputContainerView.addSubview(emailTF)
        setupEmailTF()
        
        inputContainerView.addSubview(emailSeparatorView)
        setupEmailSeparatorView()
        
        inputContainerView.addSubview(passwordTF)
        setupPasswordTF()
    }
    
    func setupPasswordTF() {
        passwordTF.leftAnchor.constraint(equalTo: inputContainerView.leftAnchor, constant: 12).isActive = true
        passwordTF.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
        passwordTF.topAnchor.constraint(equalTo: emailSeparatorView.bottomAnchor).isActive = true
        
        passwordHeightConstraint = passwordTF.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: 1/3)
        passwordHeightConstraint?.isActive = true
    }
    
    func setupEmailSeparatorView() {
        emailSeparatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        emailSeparatorView.topAnchor.constraint(equalTo: emailTF.bottomAnchor).isActive = true
        emailSeparatorView.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
    }
    
    func setupEmailTF() {
        emailTF.leftAnchor.constraint(equalTo: inputContainerView.leftAnchor, constant: 12).isActive = true
        emailTF.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
        emailTF.topAnchor.constraint(equalTo: nameSeparatorView.bottomAnchor).isActive = true
        
        emailHeightConstraint = emailTF.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: 1/3)
        emailHeightConstraint?.isActive = true
    }
    
    func setupNameSeparatorView() {
        nameSeparatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        nameSeparatorView.topAnchor.constraint(equalTo: nameTF.bottomAnchor).isActive = true
        nameSeparatorView.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
    }
    
    func setupNameTF() {
        nameTF.leftAnchor.constraint(equalTo: inputContainerView.leftAnchor, constant: 12).isActive = true
        nameTF.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
        nameTF.topAnchor.constraint(equalTo: inputContainerView.topAnchor).isActive = true
        
        nameHeightConstraint = nameTF.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: 1/3)
        nameHeightConstraint?.isActive = true
    }
}

