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
        _ = context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
        switch context.biometryType {
        case .none:
            return .none
        case .touchID:
            return .touchID
        case .faceID:
            return .faceID
        @unknown default:
            return .none
        }
    }

    func authenticateUser(completion: @escaping (String?) -> Void) { // 1
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
                        completion(nil)
                    }
                } else {
                    let message: String

                    switch evaluateError {
                    case LAError.authenticationFailed?:
                        message = "There was a problem verifying your identity."
                    case LAError.userCancel?:
                        message = "You pressed cancel."
                    case LAError.userFallback?:
                        message = "You pressed password."
                    case LAError.biometryNotAvailable?:
                        message = "Face ID/Touch ID is not available."
                    case LAError.biometryNotEnrolled?:
                        message = "Face ID/Touch ID is not set up."
                    case LAError.biometryLockout?:
                        message = "Face ID/Touch ID is locked."
                    default:
                        message = "Face ID/Touch ID may not be configured"
                    }

                    completion(message)
                }
        }
    }
}
