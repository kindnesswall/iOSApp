//
//  ViewLoadingState.swift
//  app
//
//  Created by Amir Hossein on 12/7/19.
//  Copyright © 2019 Hamed.Gh. All rights reserved.
//

import Foundation

enum ViewLoadingState {
    case loading(ViewLoadingType)
    case success
    case failed(Error)
}

enum ViewLoadingType {
    case initial
    case refresh
}
