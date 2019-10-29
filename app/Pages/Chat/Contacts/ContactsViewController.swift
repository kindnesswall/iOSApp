//
//  ContactsViewController.swift
//  KindnessWallChat
//
//  Created by Amir Hossein on 3/11/19.
//  Copyright © 2019 Amir Hossein. All rights reserved.
//

import UIKit


class ContactsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var viewModel: ContactsViewModel!
    var blockedChats = false
    var loadingIndicator: LoadingIndicator?
    let refreshControl = UIRefreshControl()
    lazy var httpLayer = HTTPLayer()
    lazy var apiService = ApiService(httpLayer)
    @IBOutlet weak var onEmptyListMessage: UIView!
    
    @IBOutlet weak var youHaveNoMessage: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.viewModel = ContactsViewModel(blockedChats: self.blockedChats)
        
        self.tableView.delegate = self
        self.tableView.dataSource = self.viewModel
        
        let titleKey = self.blockedChats ? LanguageKeys.blockedChats : LanguageKeys.chats
        self.navigationItem.title = titleKey.localizedString
        
        self.tableView.register(ChatTableViewCell.self, forCellReuseIdentifier: ChatTableViewCell.identifier)
        self.loadingIndicator=LoadingIndicator(view: self.view)
        configRefreshControl()
        
        self.viewModel.delegate = self
        
        youHaveNoMessage.text = viewModel.network.getEmptyListMessage()
        
        if self.viewModel.initialContactsHasLoaded {
            self.pageLoadingAnimation(pageLoadingSate: .hasLoaded(showEmptyListMessage: self.viewModel.allChats.count == 0))
        } else {
            self.pageLoadingAnimation(pageLoadingSate: .isLoading)
        }
        
    }
    
    func configRefreshControl(){
        refreshControl.addTarget(self, action: #selector(self.refreshControlAction), for: .valueChanged)
        refreshControl.tintColor=AppConst.Resource.Color.Tint
        tableView.addSubview(refreshControl)
    }
    
    @objc func refreshControlAction(){
        self.refreshChat()
    }
    
    deinit {
        print("ContactsViewController deinit")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.setDefaultStyle()
    }
}



extension ContactsViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let messagesViewModel = self.viewModel.allChats[indexPath.row]
        let controller = MessagesViewController()
        controller.viewModel = messagesViewModel
        controller.delegate = self.viewModel
        controller.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return ChatTableViewCell.cellHeight
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let messagesViewModel = self.viewModel.allChats[indexPath.row]
        let action = getSwipeAction(chatId: messagesViewModel.chatId)
        return UISwipeActionsConfiguration(actions: [action])
        
    }
    func getSwipeAction(chatId: Int) -> UIContextualAction {
        
        let titleKey = self.blockedChats ? LanguageKeys.unblock : LanguageKeys.block
        let title = titleKey.localizedString
        
        let action = UIContextualAction(style: .destructive, title: title) { [weak self] action, view, completion in
            
            self?.swipeHandler(chatId: chatId, completion: completion)
            
        }
        return action
    }
    
    func swipeHandler(chatId: Int, completion: @escaping (Bool)->Void ){
        
        let blockCase = self.blockedChats ? BlockCase.unblock : BlockCase.block
        self.apiService.blockOrUnblockChat(blockCase: blockCase, chatId: chatId, completion: { result in
            switch result {
            case .failure(_):
                break
            case .success(_):
                completion(true)
            }
        })
    }
}

extension ContactsViewController : ContactsViewModelProtocol {
    
    func reloadTableView() {
        self.tableView.reloadData()
    }
    
    func pageLoadingAnimation(pageLoadingSate: PageLoadingSate) {
        switch pageLoadingSate {
        case .isLoading:
            self.loadingIndicator?.startLoading()
            self.onEmptyListMessage.hide()
        case .hasLoaded(let showEmptyListMessage):
            self.loadingIndicator?.stopLoading()
            self.refreshControl.endRefreshing()
            self.onEmptyListMessage.isHidden = !showEmptyListMessage
        }
    }
}

extension ContactsViewController: RefreshChatProtocol {
    func refreshChat() {
        self.viewModel.reloadData()
    }
    func fetchChat(chatId:Int) {
        self.viewModel.loadMessages(chatId: chatId, beforeId: nil)
    }
}

enum PageLoadingSate {
    case isLoading
    case hasLoaded(showEmptyListMessage:Bool)
}

protocol RefreshChatProtocol : class {
    func refreshChat()
    func fetchChat(chatId:Int)
}
