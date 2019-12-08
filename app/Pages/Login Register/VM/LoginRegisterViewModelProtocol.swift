//
//  LoginRegisterViewModelProtocol.swift
//  app
//
//  Created by Amir Hossein on 11/9/19.
//  Copyright © 2019 Hamed.Gh. All rights reserved.
//

import Foundation

protocol LoginRegisterViewModelProtocol {
    func registerUser(with phoneNumber: String, handleResult: @escaping (Result<String?>) -> Void)
    func login(with phoneNumber: String, activationCode: String, verificationId: String?, handleResult: @escaping (Result<AuthOutput>) -> Void)
}
