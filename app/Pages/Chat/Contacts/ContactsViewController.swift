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
    var viewModel: ContactsViewModel
    var blockedChats = false
    var loadingIndicator: LoadingIndicator?
    let refreshControl = UIRefreshControl()
    lazy var httpLayer = HTTPLayer()
    lazy var apiService = ApiService(httpLayer)

    var chatCoordinator: ChatCoordinator
    init(chatCoordinator: ChatCoordinator, blockedChats: Bool) {
        self.chatCoordinator = chatCoordinator
        self.blockedChats = blockedChats
        self.viewModel = ContactsViewModel(blockedChats: blockedChats)
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @IBOutlet weak var onEmptyListMessage: UIView!

    @IBOutlet weak var youHaveNoMessage: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.delegate = self
        self.tableView.dataSource = self.viewModel

        let titleKey = blockedChats ? LanguageKeys.blockedChats : LanguageKeys.chats
        navigationItem.title = titleKey.localizedString

        self.tableView.register(ChatTableViewCell.self, forCellReuseIdentifier: ChatTableViewCell.identifier)

        self.loadingIndicator=LoadingIndicator(view: self.view)
        configRefreshControl()

        youHaveNoMessage.text = viewModel.network.getEmptyListMessage()
        
        bindViewModel()

    }

    func configRefreshControl() {
        refreshControl.addTarget(self, action: #selector(self.refreshControlAction), for: .valueChanged)
        refreshControl.tintColor=AppColor.Tint
        tableView.addSubview(refreshControl)
    }

    @objc func refreshControlAction() {
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

extension ContactsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let messagesViewModel = self.viewModel.allChats[indexPath.row]
        chatCoordinator.showMessages(viewModel: messagesViewModel, delegate: viewModel)
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

        let titleKey = blockedChats ? LanguageKeys.unblock : LanguageKeys.block
        let title = titleKey.localizedString

        let action = UIContextualAction(style: .destructive, title: title) { [weak self] _, _, completion in

            self?.swipeHandler(chatId: chatId, completion: completion)

        }
        return action
    }

    func swipeHandler(chatId: Int, completion: @escaping (Bool) -> Void ) {

        let blockCase = self.blockedChats ? BlockCase.unblock : BlockCase.block
        self.apiService.blockOrUnblockChat(blockCase: blockCase, chatId: chatId, completion: { result in
            switch result {
            case .failure:
                //TODO: should handle the failure
                break
            case .success:
                completion(true)
            }
        })
    }
}

// MARK: - Binding
extension ContactsViewController {
    
    func bindViewModel() {
        viewModel.$allChats.bind = { [weak self] _ in
            self?.tableView.reloadData()
        }
        viewModel.$loadingState.bind = { [weak self] state in
            self?.setLoading(state: state)
        }
    }
    
    func setLoading(state: ViewLoadingState) {
        switch state {
        case .loading(let type):
            if type == .initial {
                self.loadingIndicator?.startLoading()
            }
            self.onEmptyListMessage.hide()
        
        case .success:
            self.loadingIndicator?.stopLoading()
            self.refreshControl.endRefreshing()
            self.onEmptyListMessage.isHidden = true
        
        case .empty:
            self.loadingIndicator?.stopLoading()
            self.refreshControl.endRefreshing()
            self.onEmptyListMessage.isHidden = false
        
        case .failed:
            //TODO: should handle the failure
            break
        
        }
    }
}

extension ContactsViewController: RefreshChatProtocol {
    func refreshChat() {
        self.viewModel.reloadContacts()
    }
    func fetchChat(chatId: Int) {
        self.viewModel.loadMessages(chatId: chatId, beforeId: nil)
    }
}

protocol RefreshChatProtocol: class {
    func refreshChat()
    func fetchChat(chatId: Int)
}
