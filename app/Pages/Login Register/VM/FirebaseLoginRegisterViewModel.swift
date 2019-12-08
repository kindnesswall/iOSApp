//
//  FirebaseLoginRegisterViewModel.swift
//  app
//
//  Created by Amir Hossein on 11/9/19.
//  Copyright © 2019 Hamed.Gh. All rights reserved.
//

import UIKit
import FirebaseAuth

class FirebaseLoginRegisterViewModel: NSObject, LoginRegisterViewModelProtocol {

    lazy var apiService = ApiService(HTTPLayer())

    func registerUser(with phoneNumber: String, handleResult: @escaping (Result<String?>) -> Void) {
        PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: nil) { verificationId, error in

            DispatchQueue.main.async {
                guard error == nil, let verificationId = verificationId  else {
                    handleResult(.failure(AppError.firebaseError(error: error)))
                    return
                }
                handleResult(.success(verificationId))
            }

        }
    }

    func login(with phoneNumber: String, activationCode: String, verificationId: String?, handleResult: @escaping (Result<AuthOutput>) -> Void) {

        guard let verificationId = verificationId  else {
            handleResult(.failure(AppError.nilInput))
            return
        }

        let credential = PhoneAuthProvider.provider().credential(withVerificationID: verificationId, verificationCode: activationCode)

        Auth.auth().signIn(with: credential) { [weak self] result, error in

            guard error == nil, let result = result  else {

                DispatchQueue.main.async {
                    handleResult(.failure(AppError.firebaseError(error: error)))
                }

                return
            }
            result.user.getIDToken(completion: { idToken, error in

                guard error == nil, let idToken = idToken  else {
                    DispatchQueue.main.async {
                        handleResult(.failure(AppError.firebaseError(error: error)))
                    }
                    return
                }

                let input = FirebaseLoginInput(idToken: idToken)

                self?.apiService.fireBaseLogin(input: input, completion: { result in
                    DispatchQueue.main.async {
                        handleResult(result)
                    }
                })

            })
        }
    }

}
