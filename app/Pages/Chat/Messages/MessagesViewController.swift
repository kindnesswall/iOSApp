//
//  MessagesViewController.swift
//  KindnessWallChat
//
//  Created by Amir Hossein on 3/10/19.
//  Copyright © 2019 Amir Hossein. All rights reserved.
//

import UIKit
import PanModal

class MessagesViewController: UIViewController {

    @IBAction func donateGift(_ sender: Any) {
        donateGiftBtnTapped()
    }

    var blockButtonState: BlockButtonState = .unblock
    @IBOutlet weak var blockBtn: UIButton!
    @IBOutlet weak var donateGiftBtn: UIButton!

    @IBOutlet weak var sendMessageBtn: UIButton!
    @IBOutlet weak var messageInputPlaceholder: UIStackView!
    @IBOutlet weak var messageInput: UITextView!

    @IBOutlet weak var tableView: UITableView!
    var viewModel: MessagesViewModel?
    var network: MessagesViewModelParentDelegate? {
        return viewModel?.parentDelegate
    }

    var donateGiftBarBtn: UIBarButtonItem?

    lazy var httpLayer = HTTPLayer()
    lazy var apiService = ApiService(httpLayer)

    override func viewDidLoad() {
        super.viewDidLoad()

        loadBlockButtonState()

        self.configBarButtons()

        self.tableView.register(MessagesTableViewCell.self, forCellReuseIdentifier: MessagesTableViewCell.MessageUserType.user.rawValue)
        self.tableView.register(MessagesTableViewCell.self, forCellReuseIdentifier: MessagesTableViewCell.MessageUserType.others.rawValue)

        self.tableView.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
        self.tableView.reloadData()

        self.configureMessageInput()

        bindToViewModel()

        guard let viewModel = viewModel else {
            return
        }
        network?.loadMessages(chatId: viewModel.chatId, beforeId: nil)

    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.viewModel?.updateIsNewMessageForAll()
    }

    func configBarButtons() {
//        donateGiftBarBtn = UINavigationItem.getNavigationItem(
//            target: self,
//            action: #selector(self.donateGiftBtnTapped),
//            text:LanguageKeys.DonateGift.localizedString,
//            font:AppFont.getRegularFont(size: 16)
//        )

//        self.navigationItem.rightBarButtonItems=[donateGiftBarBtn!]
    }

    func loadBlockButtonState() {
        if self.viewModel?.blockStatus?.contactIsBlocked == true {
            setBlockButtonState(state: .contactBlock)
        } else {
            if self.viewModel?.blockStatus?.userIsBlocked == true {
                setBlockButtonState(state: .userBlock)
            } else {
                setBlockButtonState(state: .unblock)
            }
        }
    }

    enum BlockButtonState {
        case unblock
        case contactBlock
        case userBlock
    }

    func setBlockButtonState(state: BlockButtonState) {

        self.blockButtonState = state

        if state == .unblock {
            hideOrShowSendMessagesBtn(show: true)
            self.blockBtn.hide()
        } else {
            hideOrShowSendMessagesBtn(show: false)
            self.blockBtn.show()
        }

        switch state {
        case .unblock:
            self.blockBtn.isEnabled = false
            self.blockBtn.setTitle("", for: .normal)
        case .contactBlock:
            self.blockBtn.isEnabled = true
            self.blockBtn.setTitle(LanguageKeys.unblock.localizedString, for: .normal)
        case .userBlock:
            self.blockBtn.isEnabled = false
            self.blockBtn.setTitle(LanguageKeys.youHaveBeenBlocked.localizedString, for: .normal)
        }
    }

    func hideOrShowSendMessagesBtn(show: Bool) {
        let isHidden = !show
        self.messageInputPlaceholder.isHidden = isHidden
        self.sendMessageBtn.isHidden = isHidden
        self.donateGiftBtn.isHidden = isHidden
    }

    @IBAction func unblockAction(_ sender: Any) {
        guard blockButtonState == .contactBlock else {
            return
        }

        guard let chatId = viewModel?.chatId else {
            return
        }

        self.apiService.blockOrUnblockChat(blockCase: .unblock, chatId: chatId, completion: { [weak self] result in
            switch result {
            case .failure:
                //TODO: should handle the failure
                break
            case .success:
                self?.network?.reloadContacts()
                self?.navigationController?.popViewController(animated: true)
            }
        })

    }
    @objc func donateGiftBtnTapped() {
        let controller = GiftsToDonateViewController()
        controller.toUserId = viewModel?.getContactId()
        controller.donateGiftHandler = { [weak self] gift in
            self?.sendGiftDonationMessage(gift: gift)
        }
        let nc = UINavigationController(rootViewController: controller)
        self.present(nc, animated: true, completion: nil)
    }

    func sendGiftDonationMessage(gift: Gift) {

        let giftDonateChatMessage = LanguageKeys.giftDonateChatMessage.localizedString
        let text = "\(giftDonateChatMessage) '\(gift.title ?? "")'"

        guard let viewModel = self.viewModel else {
            return
        }

        network?.writeMessage(text: text, messagesViewModel: viewModel)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.setDefaultStyle()
        self.setAllTextsInView()
    }

    func setAllTextsInView() {
        self.donateGiftBarBtn?.title=LanguageKeys.DonateGift.localizedString
    }

    func configureMessageInput() {
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

        network?.writeMessage(text: messageText, messagesViewModel: viewModel)

    }
    
    func bindToViewModel() {
        self.viewModel?.updateMessagesBind = {[weak self] type in
            self?.updateMessagesAction(type: type)
        }
    }
    
    func updateMessagesAction(type: UpdateMessagesType) {
        self.tableView.reloadData()
        if type == .updateAndScrollToTop {
            self.scrollToTop()
        }
    }

    func scrollToTop() {
        guard self.viewModel?.curatedMessages.count ?? 0 > 0,
            self.viewModel?.curatedMessages[0].count ?? 0 > 0
        else { return }
        self.tableView.scrollToRow(at: IndexPath(item: 0, section: 0), at: .top, animated: true)
    }
}

extension MessagesViewController: UITableViewDataSource {

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

        let messageType: MessagesTableViewCell.MessageUserType
        if message.senderId == viewModel.userId {
            messageType = .user
        } else {
            messageType = .others
        }

        let cell = (tableView.dequeueReusableCell(withIdentifier: messageType.rawValue, for: indexPath) as? MessagesTableViewCell) ?? MessagesTableViewCell(style: .default, reuseIdentifier: messageType.rawValue)
        cell.updateUI(message: message, messageType: messageType)

        if indexPath.section == viewModel.curatedMessages.count-1,
        indexPath.row == viewModel.curatedMessages[indexPath.section].count-1 {
            if !viewModel.noMoreOldMessages {
                if let beforeId = message.id {
                    network?.loadMessages(chatId: viewModel.chatId, beforeId: beforeId)
                }
            }
        }

        return cell
    }

    func messageHasSeen(message: TextMessage, userId: Int) {

        message.hasSeen = true

        guard message.receiverId == userId, message.ack == false else {
            return
        }
        network?.sendAckMessage(message: message) {
            message.ack = true
        }
    }

}

extension MessagesViewController: UITableViewDelegate {

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

