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
    var rootViewController:ContactsViewController?
    
    init(navigationController: CoordinatedNavigationController = CoordinatedNavigationController()) {
        self.navigationController = navigationController
        navigationController.coordinator = self
    }
    
    func showRoot(blockedChats:Bool = false) {
        rootViewController = createViewController(blockedChats: blockedChats)
        guard let rootVC = rootViewController else {return}
        
        let img = UIImage(named: AppImages.Requests)
        rootVC.tabBarItem = UITabBarItem(title: "Chats", image: img, tag: 0)
        navigationController.viewControllers = [rootVC]
    }
    
    func createViewController(blockedChats:Bool = false) -> ContactsViewController {
        if let rootVC = rootViewController {
            return rootVC
        }
        rootViewController = ContactsViewController(chatCoordinator: self, blockedChats: blockedChats)
        self.startNewChatProtocol = rootViewController!.viewModel
        self.refreshChatProtocol = rootViewController!
        return rootViewController!
    }
    
    func showMessages(viewModel:MessagesViewModel, delegate:MessagesViewControllerDelegate) {
        let controller = MessagesViewController()
        controller.viewModel = viewModel
        controller.delegate = delegate
        controller.hidesBottomBarWhenPushed = true
        self.navigationController.pushViewController(controller, animated: true)
    }
}
