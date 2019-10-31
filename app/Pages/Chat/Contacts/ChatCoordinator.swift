//
//  ChatCoordinator.swift
//  app
//
//  Created by Hamed Ghadirian on 25.10.19.
//  Copyright © 2019 Hamed.Gh. All rights reserved.
//

import Foundation
import UIKit

class ChatCoordinator : NavigationCoordinator {
    var navigationController: CoordinatedNavigationController
    weak var startNewChatProtocol:StartNewChatProtocol?
    weak var refreshChatProtocol:RefreshChatProtocol?
    
    init(navigationController: CoordinatedNavigationController = CoordinatedNavigationController()) {
        self.navigationController = navigationController
        navigationController.coordinator = self
    }
    
    func showRoot(blockedChats:Bool = false) {
        let viewController = ContactsViewController(chatCoordinator: self, blockedChats: blockedChats)
        self.startNewChatProtocol = viewController.viewModel
        self.refreshChatProtocol = viewController
        let img = UIImage(named: AppImages.Requests)
        viewController.tabBarItem = UITabBarItem(title: "Chats", image: img, tag: 0)
        
        navigationController.viewControllers = [viewController]
    }
    
    func showMessages(viewModel:MessagesViewModel, delegate:MessagesViewControllerDelegate) {
        let controller = MessagesViewController()
        controller.viewModel = viewModel
        controller.delegate = delegate
        controller.hidesBottomBarWhenPushed = true
        self.navigationController.pushViewController(controller, animated: true)
    }
}
