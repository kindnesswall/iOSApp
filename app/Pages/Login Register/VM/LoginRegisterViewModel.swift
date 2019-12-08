//
//  LoginRegisterViewModel.swift
//  app
//
//  Created by Amir Hossein on 11/9/19.
//  Copyright © 2019 Hamed.Gh. All rights reserved.
//

import UIKit

class LoginRegisterViewModel: NSObject, LoginRegisterViewModelProtocol {

    lazy var apiService = ApiService(HTTPLayer())

    func registerUser(with phoneNumber: String, handleResult: @escaping (Result<String?>) -> Void) {
        apiService.registerUser(phoneNumber: phoneNumber) { result in
            DispatchQueue.main.async {

                switch result {
                case .success:
                    handleResult(.success(nil))
                case .failure(let error):
                    handleResult(.failure(error))
                }

            }
        }
    }

    func login(with phoneNumber: String, activationCode: String, verificationId: String?, handleResult: @escaping (Result<AuthOutput>) -> Void) {
        apiService.login(phoneNumber: phoneNumber, activationCode: activationCode) { result in
            DispatchQueue.main.async {
                handleResult(result)
            }
        }
    }

    func requestPhoneNumberChange(to newPhoneNumber: String, handleResult: @escaping (Result<Void>) -> Void) {
        apiService.requestPhoneNumberChange(to: newPhoneNumber) { result in
            DispatchQueue.main.async {
                handleResult(result)
            }
        }
    }

    func validatePhoneNumberChange(with phoneNumber: String, activationCode: String, handleResult: @escaping (Result<AuthOutput>) -> Void) {
        apiService.validatePhoneNumberChange(to: phoneNumber, with: activationCode) { result in
            DispatchQueue.main.async {
                handleResult(result)
            }
        }
    }

}
