//
//  TouchIDAuthentication.swift
//  app
//
//  Created by Hamed.Gh on 12/18/18.
//  Copyright © 2018 Hamed.Gh. All rights reserved.
//

import Foundation
import LocalAuthentication

class BiometricIDAuth {
    enum BiometricType {
        case none
        case touchID
        case faceID
    }
    
    var loginReason = "Logging in with Touch ID"
    let context = LAContext()
    
    func canEvaluatePolicy() -> Bool {
        return context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
    }
    
    func biometricType() -> BiometricType {
        let _ = context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
        switch context.biometryType {
        case .none:
            return .none
        case .touchID:
            return .touchID
        case .faceID:
            return .faceID
        }
    }
    
    func authenticateUser(completion: @escaping () -> Void) { // 1
        // 2
        guard canEvaluatePolicy() else {
            return
        }
        
        // 3
        context.evaluatePolicy(
            .deviceOwnerAuthenticationWithBiometrics,
            localizedReason: loginReason) { (success, evaluateError) in
                // 4
                if success {
                    DispatchQueue.main.async {
                        // User authenticated successfully, take appropriate action
                        AppDelegate.me().isActiveAfterBioAuth = true
                        completion()
                    }
                } else {
                    // TODO: deal with LAError cases
                }
        }
    }
}
