//
//  TabCoordinator.swift
//  app
//
//  Created by Hamed Ghadirian on 26.10.19.
//  Copyright © 2019 Hamed.Gh. All rights reserved.
//

import Foundation
import UIKit

protocol TabCoordinator: AnyObject {
    var tabBarController: TabBarController { get set }
    var appCoordinator: AppCoordinatorProtocol { get set }
}
