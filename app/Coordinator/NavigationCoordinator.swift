//
//  Coordinator.swift
//  app
//
//  Created by Hamed Ghadirian on 22.10.19.
//  Copyright © 2019 Hamed.Gh. All rights reserved.
//

import Foundation
import UIKit

class CoordinatedNavigationController: UINavigationController {
    weak var coordinator: NavigationCoordinator?
}

protocol NavigationCoordinator: AnyObject {
    var navigationController: CoordinatedNavigationController { get set }
    func present(coordinator: NavigationCoordinator)
}

extension NavigationCoordinator {
    func present(coordinator: NavigationCoordinator) {
        self.navigationController.present(coordinator.navigationController, animated: true, completion: nil)
    }
}
