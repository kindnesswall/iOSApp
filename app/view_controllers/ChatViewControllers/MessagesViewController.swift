//
//  MessagesViewController.swift
//  KindnessWallChat
//
//  Created by Amir Hossein on 3/10/19.
//  Copyright © 2019 Amir Hossein. All rights reserved.
//

import UIKit
import PanModal

class MessagesViewController: UIViewController,MessagesDelegate {
    
    @IBAction func donateGift(_ sender: Any) {
        donateGiftBtnTapped()
    }
    @IBOutlet weak var messageInput: UITextView!
    
    @IBOutlet weak var tableView: UITableView!
    var viewModel:MessagesViewModel?
    
    var donateGiftBarBtn: UIBarButtonItem?
    
    weak var delegate:MessagesViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configBarButtons()
        
        self.tableView.register(MessagesTableViewCell.self, forCellReuseIdentifier: MessagesTableViewCell.MessageUserType.user.rawValue)
        self.tableView.register(MessagesTableViewCell.self, forCellReuseIdentifier: MessagesTableViewCell.MessageUserType.others.rawValue)
        
        self.tableView.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
        self.tableView.reloadData()
        
        self.configureMessageInput()
        
        self.viewModel?.delegate = self
        
        guard let viewModel = viewModel else {
            return
        }
        self.delegate?.loadMessages(chatId: viewModel.chatId, beforeId: nil)
        
    }
    
    func configBarButtons(){
//        donateGiftBarBtn = UINavigationItem.getNavigationItem(
//            target: self,
//            action: #selector(self.donateGiftBtnTapped),
//            text:LocalizationSystem.getStr(forKey: LanguageKeys.DonateGift),
//            font:AppConst.Resource.Font.getRegularFont(size: 16)
//        )
        
//        self.navigationItem.rightBarButtonItems=[donateGiftBarBtn!]
    }
    
    @objc func donateGiftBtnTapped(){
        let controller = GiftsToDonateViewController()
        controller.toUserId = viewModel?.getContactId()
        controller.donateGiftHandler = { [weak self] gift in
            self?.sendGiftDonationMessage(gift: gift)
        }
        self.navigationController?.presentPanModal(controller)
//        pushViewController(controller, animated: true)
    }
    
    func sendGiftDonationMessage(gift:Gift){
        
        let giftDonateChatMessage = LocalizationSystem.getStr(forKey: LanguageKeys.giftDonateChatMessage)
        let text = "\(giftDonateChatMessage) '\(gift.title ?? "")'"
        
        guard let viewModel = self.viewModel else {
            return
        }
        
        self.delegate?.writeMessage(text: text, messagesViewModel: viewModel)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.setDefaultStyle()
        self.setAllTextsInView()
    }
    
    func setAllTextsInView(){
        self.donateGiftBarBtn?.title=LocalizationSystem.getStr(forKey: LanguageKeys.DonateGift)
    }
    
    func configureMessageInput(){
        self.messageInput.layer.borderColor = UIColor.black.cgColor
        self.messageInput.layer.borderWidth = 1
        self.messageInput.layer.cornerRadius = 10
        self.messageInput.layer.masksToBounds = true
        
        self.messageInput.isScrollEnabled = false
        self.messageInput.sizeToFit()
    }
    
    deinit {
        print("MessagesViewController deinit")
    }
    @IBAction func sendMessage(_ sender: Any) {
        guard let messageText = self.messageInput.text, messageText != "" else {
            return
        }
        self.messageInput.text = ""
        
        guard let viewModel = self.viewModel else {
            return
        }
        
        self.delegate?.writeMessage(text: messageText, messagesViewModel: viewModel)
        
    }
    
    func updateTableViewAndScrollToTop() {
        self.tableView.reloadData()
        self.scrollToTop()
    }
    func updateTableView() {
        self.tableView.reloadData()
    }
    
    func scrollToTop(){
        self.tableView.scrollToRow(at: IndexPath(item: 0, section: 0), at: .top, animated: true)
    }
}

extension MessagesViewController : UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.viewModel?.curatedMessages.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel?.curatedMessages[section].count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let viewModel = self.viewModel else {
            return UITableViewCell()
        }
        let message = viewModel.curatedMessages[indexPath.section][indexPath.row]
        
        messageHasSeen(message: message, userId: viewModel.userId)
        
        let messageType:MessagesTableViewCell.MessageUserType
        if message.senderId == viewModel.userId {
            messageType = .user
        } else {
            messageType = .others
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: messageType.rawValue, for: indexPath) as! MessagesTableViewCell
        cell.updateUI(message: message, messageType: messageType)
        
        if indexPath.section == viewModel.curatedMessages.count-1,
        indexPath.row == viewModel.curatedMessages[indexPath.section].count-1 {
            if !viewModel.noMoreOldMessages {
                if let beforeId = message.id {
                    self.delegate?.loadMessages(chatId: viewModel.chatId, beforeId: beforeId)
                }
            }
        }
        
        return cell
    }
    
    func messageHasSeen(message:TextMessage, userId:Int){
        
        message.hasSeen = true
        
        guard message.receiverId == userId, message.ack == false else {
            return
        }
        self.delegate?.sendAckMessage(message: message)
    }
    
    
}

extension MessagesViewController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let message = self.viewModel?.curatedMessages[section].first
        let messagesDateTableViewCell = MessagesDateTableViewCell(style: .default, reuseIdentifier: MessagesDateTableViewCell.identifier)
        messagesDateTableViewCell.updateUI(date: message?.createdAt?.convertToDate()?.getPersianDate())
        return messagesDateTableViewCell
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return MessagesDateTableViewCell.height
    }
}

protocol MessagesViewControllerDelegate : class{
    func writeMessage(text:String,messagesViewModel:MessagesViewModel)
    func loadMessages(chatId:Int,beforeId:Int?)
    func sendAckMessage(message:TextMessage)
}
