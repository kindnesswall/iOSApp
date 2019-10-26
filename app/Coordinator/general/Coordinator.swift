//
//  Coordinator.swift
//  app
//
//  Created by Hamed Ghadirian on 22.10.19.
//  Copyright © 2019 Hamed.Gh. All rights reserved.
//

import Foundation
import UIKit

import Foundation
import UIKit

class CoordinatedNavigationController: UINavigationController {
    weak var coordinator: Coordinator?
}

protocol Coordinator:AnyObject {
    var navigationController: CoordinatedNavigationController { get set }
}
