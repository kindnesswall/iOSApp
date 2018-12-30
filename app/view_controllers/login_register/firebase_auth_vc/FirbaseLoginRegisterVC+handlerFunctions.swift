//
//  LoginRegisterVC+handlerFunctions.swift
//  SwiftMessenger
//
//  Created by Hamed.Gh on 12/23/18.
//  Copyright © 2018 MacBook Pro. All rights reserved.
//

import Foundation
import Firebase

extension FirbaseLoginRegisterVC {
    func handleRegister(_ email:String,_ password:String) {
        
        guard let name = self.nameTF.text else {
            print("please enter your name correctly!")
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: password) { [weak self](authResult, error) in
            // ...
            if let error = error {
                print("couldn't create user.the error is: \(error)")
                return
            }
            
            print("user created")
            guard let user = authResult?.user else {
                print("user not created!")
                return
            }
            
            self?.uploadProfileImage(completionHandler: { [weak self](downloadUrl) in
                self?.saveUserOnFIRDatabase(
                    info: [
                        Const.Keys.User.NAME : name,
                        Const.Keys.User.EMAIL : email,
                        Const.Keys.User.PROFILE_IMG_URL : downloadUrl
                    ]
                )
            })
        }
    }
    
    func uploadProfileImage(completionHandler: @escaping (String)->()) {
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        
//        let resizedImage = self.profileImageView.image?.resizeImage(targetSize: CGSize(width: 300, height: 300))
        guard let imageData = self.profileImageView.image?.jpegData(compressionQuality: 0.1) else { return }
//        self.profileImageView.image?.jpegData(compressionQuality: 0.1)
        
        let storageRef = Storage.storage().reference().child(AppConst.FIRUrls.Storage.IMAGES).child("\(uid).jpg")
        
        storageRef.putData(imageData, metadata: nil, completion: { (storageMetaData, error) in
            if error != nil {
                print("storage error : \(error)")
                return
            }
            print("upload successfully!")
            storageRef.downloadURL(completion: { (url, error) in
                guard let downloadURL = url else {
                    // Uh-oh, an error occurred!
                    return
                }
                completionHandler(downloadURL.absoluteString)
            })
            
        })
    }
    
    func saveUserOnFIRDatabase(info:[String:Any]) {
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        
        let ref = Database.database().reference()
        let usersRef = ref.child(AppConst.FIRUrls.Database.USERS).child(uid)
        usersRef.updateChildValues(
            info
            ,withCompletionBlock: { (err, ref) in
                if let err = err {
                    print("update child values error is : \(err)")
                    return
                }
                
                let user = FirebaseUser(dictionary: info)
//                self.messagesController?.setupNavBarWithUser(user)
                
                self.dismiss(animated: true, completion: {
                    
                })
                print("Successfully saved in users!")
        })
    }
    
    func handleLogin(_ email:String,_ password:String) {
        Auth.auth().signIn(withEmail: email, password: password) { (authDataResult, error) in
            if error != nil {
                print("login error: \(error)")
                return
            }
//            self.messagesController?.fetchUserAndSetupNavBarTitle()
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc func handleLoginRegisterBtnClicked() {
        print("clicked")
        guard let email = emailTF.text, let password = passwordTF.text else {return}
        
        if loginRegisterSegmentControl.selectedSegmentIndex == 0 {
            handleLogin(email, password)
        }else{
            handleRegister( email, password)
        }
    }
    
    @objc func handleSegmentedControlChange(){
        let title = loginRegisterSegmentControl.titleForSegment(at: loginRegisterSegmentControl.selectedSegmentIndex)
        loginRegisterBtn.setTitle(title, for: .normal)
        
        inputContainerViewHeightConstraint?.constant =
            loginRegisterSegmentControl.selectedSegmentIndex == 0 ? 100 : 150
        
        //        nameTF.isHidden = loginRegisterSegmentControl.selectedSegmentIndex == 0 ? true : false
        
        nameHeightConstraint?.isActive = false
        nameHeightConstraint = nameTF.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: loginRegisterSegmentControl.selectedSegmentIndex == 0 ? 0 : 1/3)
        nameHeightConstraint?.isActive = true
        
        emailHeightConstraint?.isActive = false
        emailHeightConstraint = emailTF.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: loginRegisterSegmentControl.selectedSegmentIndex == 0 ? 1/2 : 1/3)
        emailHeightConstraint?.isActive = true
        
        passwordHeightConstraint?.isActive = false
        passwordHeightConstraint = passwordTF.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: loginRegisterSegmentControl.selectedSegmentIndex == 0 ? 1/2 : 1/3)
        passwordHeightConstraint?.isActive = true
    }
}
