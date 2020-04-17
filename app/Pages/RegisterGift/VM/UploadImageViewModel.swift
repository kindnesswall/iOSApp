//
//  UploadImageViewModel.swift
//  app
//
//  Created by Amir Hossein on 4/17/20.
//  Copyright © 2020 Hamed.Gh. All rights reserved.
//

import UIKit

class UploadImageViewModel: NSObject {

    weak var task: URLSessionUploadTask?
    var uploadURL: String?
}
