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
    let viewModel = ContactsViewModel()
    var loadingIndicator: LoadingIndicator?
    let refreshControl = UIRefreshControl()
    @IBOutlet weak var onEmptyListMessage: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = LocalizationSystem.getStr(forKey: LanguageKeys.chats)
        
        self.tableView.register(ChatTableViewCell.self, forCellReuseIdentifier: ChatTableViewCell.identifier)
        self.loadingIndicator=LoadingIndicator(view: self.view)
        configRefreshControl()
        
        self.viewModel.delegate = self
        
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
        self.viewModel.reloadData()
    }
    
    deinit {
        print("ContactsViewController deinit")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.setDefaultStyle()
    }
}

extension ContactsViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.allChats.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ChatTableViewCell.identifier, for: indexPath) as! ChatTableViewCell
        let messagesViewModel = self.viewModel.allChats[indexPath.row]
        cell.fillUI(viewModel: messagesViewModel)
        return cell
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
    
    func socketConnected() {
        self.navigationItem.title = LocalizationSystem.getStr(forKey: LanguageKeys.chats)
    }
    
    func socketDisConnected() {
        self.navigationItem.title = LocalizationSystem.getStr(forKey: LanguageKeys.connecting)
    }
    
}

enum PageLoadingSate {
    case isLoading
    case hasLoaded(showEmptyListMessage:Bool)
}


