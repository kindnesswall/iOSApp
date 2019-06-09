//
//  Result.swift
//  app
//
//  Created by Hamed Ghadirian on 02.06.19.
//  Copyright © 2019 Hamed.Gh. All rights reserved.
//

import Foundation

enum Result<T> {
    case success(T)
    case failure(AppError)
}

