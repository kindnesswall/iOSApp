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
        
    }
    
    func sendAck(messageId: Int) {
        
    }
    
    func fetchContacts() {
        apiRequest.fetchContacts { result in
            switch result {
            case .success(let contactMessages):
                for contactMessage in contactMessages {
                    self.delegate?.contactMessageIsReceived(contactMessage: contactMessage)
                }
            default:
                break
            }
        }
    }
    
    func fetchMessages(chatId: Int, beforeId: Int?) {
        let input = FetchMessagesInput(chatId: chatId, beforeId: beforeId)
        apiRequest.fetchMessages(input: input) { result in
            switch result {
            case .success(let contactMessage):
                
                guard let textMessages = contactMessage.textMessages,
                    let chatId = contactMessage.chat?.id
                else { break }
                
                if textMessages.count != 0 {
                    self.delegate?.contactMessageIsReceived(contactMessage: contactMessage)
                } else {
                    self.delegate?.noMoreOldMessagesIsReceived(chatId: chatId)
                }
                
            default:
                break
            }
        }
        
        
    }
    
    
}
