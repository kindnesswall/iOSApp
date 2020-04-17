//
//  AppError.swift
//  app
//
//  Created by Hamed Ghadirian on 02.06.19.
//  Copyright © 2019 Hamed.Gh. All rights reserved.
//

import Foundation

public enum AppError: Error {
    case invalidInput
    case nilInput
    case apiUrlProblem
    case noInternet
    case dataDecoding
    case serverError
    case dbFetch
    case noData
    case clientSide(message: String)
    case firebaseError(error: Error?)
    case countryIsNotSpecified
    case dataToUploadNotFound
    case unknown
}
