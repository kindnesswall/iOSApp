//
//  AppError.swift
//  app
//
//  Created by Hamed Ghadirian on 02.06.19.
//  Copyright © 2019 Hamed.Gh. All rights reserved.
//

import Foundation

public enum AppError: Error {
    case InvalidInput
    case ApiUrlProblem
    case NoInternet
    case DataDecoding
    case ServerError
    case DBFetch
    case NoData
    case ClientSide(message:String)
    case Unknown
}
