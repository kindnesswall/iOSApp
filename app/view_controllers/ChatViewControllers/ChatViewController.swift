//
//  ChatViewController.swift
//  KindnessWallChat
//
//  Created by Amir Hossein on 3/11/19.
//  Copyright © 2019 Amir Hossein. All rights reserved.
//

import UIKit


class ChatViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    let viewModel = ChatViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel.delegate = self
        self.tableView.register(ChatTableViewCell.self, forCellReuseIdentifier: ChatTableViewCell.identifier)
        self.navigationItem.title = LocalizationSystem.getStr(forKey: LanguageKeys.chats)
        // Do any additional setup after loading the view.
    }
    deinit {
        print("ChatViewController deinit")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.setDefaultStyle()
        self.reload()
    }
}

extension ChatViewController : UITableViewDataSource {
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

extension ChatViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let messagesViewModel = self.viewModel.allChats[indexPath.row]
        let controller = MessagesViewController()
        controller.viewModel = messagesViewModel
        controller.delegate = self.viewModel
        controller.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(controller, animated: true)
    }
}

extension ChatViewController : ChatViewModelProtocol {
    func socketConnected() {
        self.navigationItem.title = LocalizationSystem.getStr(forKey: LanguageKeys.chats)
    }
    
    func socketDisConnected() {
        self.navigationItem.title = LocalizationSystem.getStr(forKey: LanguageKeys.connecting)
    }
    
    func reload() {
        self.tableView.reloadData()
    }
}


