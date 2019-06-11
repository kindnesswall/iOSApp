//
//  ContactsViewModel.swift
//  KindnessWallChat
//
//  Created by Amir Hossein on 3/11/19.
//  Copyright © 2019 Amir Hossein. All rights reserved.
//

import UIKit

import KeychainSwift

class ContactsViewModel: NSObject {
    
    
    var userId :Int
    var allChats = [MessagesViewModel]()
    
    weak var delegate : ContactsViewModelProtocol?
    
    var network: ContactsViewModelNetwork
    
    override init() {
        let userId = Int(KeychainSwift().get(AppConst.KeyChain.USER_ID) ?? "")
        self.userId = userId ?? -1
        
        network = ContactsSocketViewModel()
        super.init()
        
        network.delegate = self
        
    }
    
    deinit {
        print("ContactsViewModel deinit")
    }
    
    
    func addMessage(message:TextMessage,isSending:Bool,messagesViewModel:MessagesViewModel){
        
        messagesViewModel.addMessage(message: message,isSending: isSending)
        self.delegate?.reload()
        
    }
    
    
    
    private func addContact(chatId:Int,contactInfo:ContactInfo?)->MessagesViewModel{
        let messagesViewModel : MessagesViewModel = {
            if let messagesViewModel = MessagesViewModel.find(chatId: chatId, list: self.allChats) {
                return messagesViewModel
            } else {
                let messagesViewModel = MessagesViewModel(userId: self.userId, chatId: chatId)
                self.allChats.append(messagesViewModel)
                return messagesViewModel
            }
        }()
        
        if let contactInfo = contactInfo {
            messagesViewModel.contactInfo = contactInfo
        }
        
        return messagesViewModel
    }
    
    func sendAck(textMessage:TextMessage){
        guard textMessage.receiverId == userId, textMessage.ack == false else {
            return
        }
        guard let messageId=textMessage.id else {
            return
        }
        
        network.sendAck(messageId: messageId)
    }
}

extension ContactsViewModel : ContactsViewModelNetworkInterface {
    
    func contactMessagesIsReceived(contactMessages:[ContactMessage]){
        for contactMessage in contactMessages {
            contactMessageIsReceived(contactMessage: contactMessage)
        }
    }
    
    func contactMessageIsReceived(contactMessage:ContactMessage){
        
        guard let chatId = contactMessage.chat?.id  else {
            return
        }
        
        let messagesViewModel = addContact(chatId: chatId, contactInfo: contactMessage.contactInfo)
        
        guard let textMessages = contactMessage.textMessages else {
            return
        }
        
        for textMessage in textMessages {
            self.addMessage(message: textMessage, isSending: false, messagesViewModel: messagesViewModel)
        }
    }
    
    func ackMessageIsReceived(ackMessage:AckMessage){
        guard let textMessage = ackMessage.textMessage else {
            return
        }
        
        guard let chatModel = MessagesViewModel.find(chatId: textMessage.chatId, list: self.allChats) else {
            return
        }
        
        chatModel.ackMessageIsReceived(message: textMessage)
        
    }
    
    func noMoreOldMessagesIsReceived(chatId:Int){
        guard let messagesViewModel = MessagesViewModel.find(chatId: chatId, list: self.allChats) else { return }
        messagesViewModel.noMoreOldMessages = true
    }
    
    func tryAgainAllSendingMessages(){
        for eachChat in allChats {
            for eachMessage in eachChat.sendingQueue {
                network.sendTextMessage(textMessage: eachMessage)
            }
        }
    }
}


extension ContactsViewModel : MessagesViewControllerDelegate {
    
    func writeMessage(text:String,messagesViewModel:MessagesViewModel){
        
        let message = TextMessage(text: text, senderId: self.userId, chatId: messagesViewModel.chatId)
        
        self.addMessage(message: message, isSending: true, messagesViewModel: messagesViewModel)
        
        network.sendTextMessage(textMessage: message)
        
    }
    
    func loadMessages(chatId:Int,beforeId:Int?){
        network.fetchMessages(chatId: chatId, beforeId: beforeId)
    }
    
    func sendAckMessage(textMessage:TextMessage) {
        self.sendAck(textMessage: textMessage)
    }
}

extension ContactsViewModel : StartNewChatProtocol {
    
    func writeMessage(text:String,chatId:Int)->MessagesViewModel{
        
        let message = TextMessage(text: text, senderId: self.userId, chatId: chatId)
        
        let messagesViewModel = self.addContact(chatId: chatId, contactInfo: nil)
        
        self.addMessage(message: message, isSending: true, messagesViewModel: messagesViewModel)
        
        network.sendTextMessage(textMessage: message)
        
        return messagesViewModel
    }
    
    func getMessagesViewControllerDelegate() -> MessagesViewControllerDelegate {
        return self
    }
}

protocol ContactsViewModelProtocol : class {
    func reload()
    func socketConnected()
    func socketDisConnected()
}

protocol ContactsViewModelNetwork : class {
    var delegate : ContactsViewModelNetworkInterface? { get set }
    func sendTextMessage(textMessage:TextMessage)
    func sendAck(messageId:Int)
    func fetchContacts()
    func fetchMessages(chatId:Int,beforeId:Int?)
}

protocol ContactsViewModelNetworkInterface : class {
    func contactMessagesIsReceived(contactMessages:[ContactMessage])
    func ackMessageIsReceived(ackMessage:AckMessage)
    func noMoreOldMessagesIsReceived(chatId:Int)
    func tryAgainAllSendingMessages()
}

protocol StartNewChatProtocol : class {
    func writeMessage(text:String,chatId:Int)->MessagesViewModel
    func getMessagesViewControllerDelegate()->MessagesViewControllerDelegate
}
