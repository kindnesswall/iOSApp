//
//  ContactsRestfulViewModel.swift
//  app
//
//  Created by Amir Hossein on 6/11/19.
//  Copyright © 2019 Hamed.Gh. All rights reserved.
//

import UIKit

class ContactsRestfulViewModel: NSObject {

    weak var interface: ContactsViewModelNetworkInterface?
    lazy var httpLayer = HTTPLayer()
    lazy var apiService = ApiService(httpLayer)
    let blockedChats: Bool

    init(blockedChats: Bool) {
        self.blockedChats = blockedChats
        super.init()
        self.fetchContacts()
    }

    deinit {
        print("ContactsRestfulViewModel deinit")
    }

    func getEmptyListMessage() -> String {
        return blockedChats ? LanguageKeys.YouDidntBlockAnyBody.localizedString : LanguageKeys.YouHaveNoMessage.localizedString
    }

}

extension ContactsRestfulViewModel: ContactsViewModelNetwork {
    func sendTextMessage(textMessage: TextMessage) {
        apiService.sendTextMessage(textMessage: textMessage) { result in
            switch result {
            case .success(let textMessage):
                DispatchQueue.main.async {
                    self.interface?.ackMessageIsReceived(textMessage: textMessage)
                }
            default:
                break
            }
        }
    }

    func sendAck(ackMessage: AckMessage, completionHandler:(() -> Void)?) {
        apiService.sendAck(ackMessage: ackMessage) { result in
            switch result {
            case .success:
                completionHandler?()
            default:
                break
            }
        }
    }

    func fetchContacts() {
        apiService.getContacts(blockedChats: self.blockedChats) { result in
            switch result {
            case .success(let contactMessages):
                DispatchQueue.main.async {
                    self.fetchContactsIsCompleted(contactMessages: contactMessages)
                }
            default:
                break
            }
        }
    }

    func fetchContactsIsCompleted(contactMessages: [ContactMessage]) {
        self.interface?.allContactMessagesAreReceived(contactMessages: contactMessages)
    }

    func fetchMessages(chatId: Int, beforeId: Int?) {
        let input = FetchMessagesInput(chatId: chatId, beforeId: beforeId)
        apiService.fetchMessages(input: input) { result in
            switch result {
            case .success(let contactMessage):

                DispatchQueue.main.async {
                    self.fetchMessagesIsCompleted(contactMessage: contactMessage)
                }

            default:
                break
            }
        }

    }

    func fetchMessagesIsCompleted(contactMessage: ContactMessage) {
        guard let textMessages = contactMessage.textMessages,
            let chatId = contactMessage.chat?.chatId
            else { return }

        if textMessages.count != 0 {
            self.interface?.singleContactMessageIsReceived(contactMessage: contactMessage)
        } else {
            self.interface?.noMoreOldMessagesIsReceived(chatId: chatId)
        }
    }

}
