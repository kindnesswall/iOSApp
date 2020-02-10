//
//  ContactsViewModel.swift
//  KindnessWallChat
//
//  Created by Amir Hossein on 3/11/19.
//  Copyright © 2019 Amir Hossein. All rights reserved.
//

import UIKit

class ContactsViewModel: NSObject {

    var userId: Int
    @BindingWrapper var allChats = [MessagesViewModel]()
    @BindingWrapper var loadingState: ViewLoadingState = .loading(.initial)

    var network: ContactsViewModelNetwork

    init(blockedChats: Bool) {
        let userId = Int(KeychainService().getString(.userId) ?? "")
        self.userId = userId ?? -1

        network = ContactsRestfulViewModel(blockedChats: blockedChats)
        super.init()

        network.delegate = self
    }

    deinit {
        print("ContactsViewModel deinit")
    }

    private func reloadData() {
        loadingState = .loading(.refresh)
        self.allChats = []
        network.fetchContacts()
    }

    func addMessages(messages: [TextMessage], isSending: Bool, messagesViewModel: MessagesViewModel) {

        messagesViewModel.addMessages(messages: messages, isSending: isSending)

    }

    private func addContact(chatId: Int) -> MessagesViewModel {
        if let messagesViewModel = MessagesViewModel.find(chatId: chatId, list: self.allChats) {
            return messagesViewModel
        } else {
            let messagesViewModel = MessagesViewModel(userId: self.userId, chatId: chatId, parentDelegate: self)
            self.allChats.append(messagesViewModel)
            return messagesViewModel
        }
    }

}

extension ContactsViewModel: ContactsViewModelNetworkInterface {

    func allContactMessagesAreReceived(contactMessages: [ContactMessage]) {
        if contactMessages.count != 0 {
            loadingState = .success
        } else {
            loadingState = .empty
        }
        for contactMessage in contactMessages {
            self.contactMessageIsReceived(contactMessage: contactMessage)
        }
    }
    func singleContactMessageIsReceived(contactMessage: ContactMessage) {
        self.contactMessageIsReceived(contactMessage: contactMessage)
    }

    private func contactMessageIsReceived(contactMessage: ContactMessage) {

        guard let chatId = contactMessage.chatContacts?.chatId  else {
            return
        }

        let messagesViewModel = addContact(chatId: chatId)

        if let contactProfile = contactMessage.contactProfile {
            messagesViewModel.contactProfile = contactProfile
        }
        if let notificationCount = contactMessage.notificationCount {
            messagesViewModel.serverNotificationCount = notificationCount
        }
        if let blockStatus = contactMessage.blockStatus {
            messagesViewModel.blockStatus = blockStatus
        }

        guard let textMessages = contactMessage.textMessages else {
            return
        }

        self.addMessages(messages: textMessages, isSending: false, messagesViewModel: messagesViewModel)

        //Updating notification's count
        self.$allChats.hasSet()

    }

    func ackMessageIsReceived(ackMessage: AckMessage) {
        guard let textMessage = ackMessage.textMessage else {
            return
        }

        guard let chatModel = MessagesViewModel.find(chatId: textMessage.chatId, list: self.allChats) else {
            return
        }

        chatModel.ackMessageIsReceived(message: textMessage)

    }

    func noMoreOldMessagesIsReceived(chatId: Int) {
        guard let messagesViewModel = MessagesViewModel.find(chatId: chatId, list: self.allChats) else { return }
        messagesViewModel.noMoreOldMessages = true
    }

    func tryAgainAllSendingMessages() {
        for eachChat in allChats {
            for eachMessage in eachChat.sendingQueue {
                network.sendTextMessage(textMessage: eachMessage)
            }
        }
    }
}

extension ContactsViewModel: MessagesViewModelParentDelegate {

    func writeMessage(text: String, messagesViewModel: MessagesViewModel) {

        let message = TextMessage(text: text, senderId: self.userId, chatId: messagesViewModel.chatId)

        self.addMessages(messages: [message], isSending: true, messagesViewModel: messagesViewModel)

        network.sendTextMessage(textMessage: message)

    }

    func loadMessages(chatId: Int, beforeId: Int?) {
        network.fetchMessages(chatId: chatId, beforeId: beforeId)
    }

    func sendAckMessage(message: TextMessage, completionHandler:(() -> Void)?) {
        guard let messageId=message.id else {
            return
        }

        //Updating notification's count
        self.$allChats.hasSet()

        let ackMessage = AckMessage(messageId: messageId)
        network.sendAck(ackMessage: ackMessage, completionHandler: completionHandler)
    }

    func reloadContacts() {
        self.reloadData()
    }
}

extension ContactsViewModel: StartNewChatProtocol {

    func writeMessage(text: String?, chatId: Int) -> MessagesViewModel {

        let messagesViewModel = self.addContact(chatId: chatId)

        if let text = text {
            let message = TextMessage(text: text, senderId: self.userId, chatId: chatId)
            self.addMessages(messages: [message], isSending: true, messagesViewModel: messagesViewModel)
            network.sendTextMessage(textMessage: message)
        }

        return messagesViewModel
    }
}

protocol ContactsViewModelNetwork: class {
    var delegate: ContactsViewModelNetworkInterface? { get set }
    func sendTextMessage(textMessage: TextMessage)
    func sendAck(ackMessage: AckMessage, completionHandler:(() -> Void)?)
    func fetchContacts()
    func fetchMessages(chatId: Int, beforeId: Int?)
    func getEmptyListMessage() -> String
}

protocol ContactsViewModelNetworkInterface: class {
    func allContactMessagesAreReceived(contactMessages: [ContactMessage])
    func singleContactMessageIsReceived(contactMessage: ContactMessage)
    func ackMessageIsReceived(ackMessage: AckMessage)
    func noMoreOldMessagesIsReceived(chatId: Int)
    func tryAgainAllSendingMessages()
}

protocol StartNewChatProtocol: class {
    func writeMessage(text: String?, chatId: Int) -> MessagesViewModel
}
