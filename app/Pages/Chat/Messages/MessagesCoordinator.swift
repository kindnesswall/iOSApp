//
//  MessagesCoordinator.swift
//  app
//
//  Created by Amir Hossein on 2/15/20.
//  Copyright © 2020 Hamed.Gh. All rights reserved.
//

import UIKit

class MessagesCoordinator: NavigationCoordinator {
    var navigationController: CoordinatedNavigationController
    
    lazy var wallCoordinator = MyWallCoordinator(navigationController: navigationController)
    
    init(navigationController: CoordinatedNavigationController) {
        self.navigationController = navigationController
    }
    
    func showMessages(viewModel: MessagesViewModel) {
        let controller = MessagesViewController(coordinator: self)
        controller.viewModel = viewModel
        controller.hidesBottomBarWhenPushed = true
        self.navigationController.pushViewController(controller, animated: true)
    }
    
    func showContactsWall(contactId: Int) {
        wallCoordinator.pushContactWall(contactId: contactId)
    }
}
