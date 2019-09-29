//
//  ContactsRestfulViewModel.swift
//  app
//
//  Created by Amir Hossein on 6/11/19.
//  Copyright © 2019 Hamed.Gh. All rights reserved.
//

import UIKit

class ContactsRestfulViewModel: NSObject {

    weak var delegate : ContactsViewModelNetworkInterface?
    lazy var httpLayer = HTTPLayer()
    lazy var apiRequest = ApiRequest(httpLayer)
    
    override init() {
        super.init()
        self.fetchContacts()
    }
    
    deinit {
        print("ContactsRestfulViewModel deinit")
    }
    
}

extension ContactsRestfulViewModel : ContactsViewModelNetwork {
    func sendTextMessage(textMessage: TextMessage) {
        apiRequest.sendTextMessage(textMessage: textMessage) { result in
            switch result {
            case .success(let ackMessage):
                DispatchQueue.main.async {
                    self.delegate?.ackMessageIsReceived(ackMessage: ackMessage)
                }
            default:
                break
            }
        }
    }
    
    func sendAck(ackMessage:AckMessage,completionHandler:(()->Void)?) {
        apiRequest.sendAck(ackMessage: ackMessage) { result in
            switch result {
            case .success(_):
                completionHandler?()
            default:
                break
            }
        }
    }
    
    func fetchContacts() {
        apiRequest.getContacts { result in
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
    
    func fetchContactsIsCompleted(contactMessages:[ContactMessage]){
        self.delegate?.allContactMessagesAreReceived(contactMessages: contactMessages)
    }
    
    func fetchMessages(chatId: Int, beforeId: Int?) {
        let input = FetchMessagesInput(chatId: chatId, beforeId: beforeId)
        apiRequest.fetchMessages(input: input) { result in
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
    
    func fetchMessagesIsCompleted(contactMessage:ContactMessage){
        guard let textMessages = contactMessage.textMessages,
            let chatId = contactMessage.chat?.id
            else { return }
        
        if textMessages.count != 0 {
            self.delegate?.singleContactMessageIsReceived(contactMessage: contactMessage)
        } else {
            self.delegate?.noMoreOldMessagesIsReceived(chatId: chatId)
        }
    }
    
    
}
