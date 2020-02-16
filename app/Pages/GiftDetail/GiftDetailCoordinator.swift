//
//  GiftDetailCoordinator.swift
//  app
//
//  Created by Hamed Ghadirian on 27.10.19.
//  Copyright © 2019 Hamed.Gh. All rights reserved.
//

import Foundation
import UIKit

class GiftDetailCoordinator: NavigationCoordinator {
    var navigationController: CoordinatedNavigationController
    
    lazy var messagesCoordinator = MessagesCoordinator(navigationController: self.navigationController)

    init(navigationController: CoordinatedNavigationController) {
        self.navigationController = navigationController
    }

    func showGiftDetailOf(_ gift: Gift, editHandler:(() -> Void)?) {
        let controller = getGiftDetailVCFor(gift, editHandler)
        navigationController.pushViewController(controller, animated: true)
    }

    func getGiftDetailVCFor(_ gift: Gift, _ editHandler:(() -> Void)?) -> UIViewController {
        let controller = GiftDetailViewController(coordinator: self)
        controller.gift = gift
        controller.editHandler = editHandler
        return controller
    }
    
    func showMessages(viewModel: MessagesViewModel) {
        messagesCoordinator.showMessages(viewModel: viewModel)
    }
}
