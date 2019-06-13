//
//  MessagesViewModel.swift
//  KindnessWallChat
//
//  Created by Amir Hossein on 3/11/19.
//  Copyright © 2019 Amir Hossein. All rights reserved.
//

import Foundation


class MessagesViewModel {
    var userId:Int
    var chatId:Int
    var contactInfo:ContactInfo?
    var serverNotificationCount: Int?
    private var messages = [TextMessage]() {
        didSet {
            updateCuratedMessages()
        }
    }
    var curatedMessages = [[TextMessage]]()
    var sendingQueue = [TextMessage]()
    weak var delegate:MessagesDelegate?
    var noMoreOldMessages = false
    
    init(userId:Int,chatId:Int) {
        self.userId=userId
        self.chatId=chatId
    }
    
    deinit {
        print("MessagesViewModel deinit")
    }
    
    var notificationCount: Int {
        if self.messages.count == 0 {
            return serverNotificationCount ?? 0
        } else {
            return localNotificationCount
        }
    }
    
    private var localNotificationCount: Int {
        var number = 0
        for each in self.messages {
            if each.senderId != self.userId, each.ack == false, each.hasSeen ?? false == false {
                number+=1
            }
        }
        return number
    }
    
    func updateCuratedMessages(){
        var curatedMessagesStorage = [[TextMessage]]()
        var lastDate:String? = nil
        var sameDateMessages:[TextMessage] = []
        for message in messages {
            
            var sendDate = message.createdAt?.convertToDate()
            if sendDate == nil, message.sendingState == .sending {
                sendDate = Date()
            }
            
            guard let date = sendDate?.getPersianDate() else {
                continue
            }
            
            //For the first item
            if lastDate == nil {
                lastDate = date
            }
            
            if lastDate != date {
                curatedMessagesStorage.append(sameDateMessages)
                sameDateMessages = []
                lastDate = date
            }
            
            sameDateMessages.append(message)
            
        }
        
        curatedMessagesStorage.append(sameDateMessages)
        
        self.curatedMessages = curatedMessagesStorage
    }
    
    
    func getContactId()->Int?{
        return contactInfo?.id
    }
    
    func addMessage(message:TextMessage,isSending:Bool) {
        if isSending {
            self.insertToMessages(message, at: 0)
            self.sendingQueue.append(message)
        } else {
            self.addServerMessage(message: message)
        }
    }
    
    func ackMessageIsReceived(message:TextMessage) {
        self.updateAckedMessage(message: message)
    }
    
    private func updateAckedMessage(message:TextMessage){
        self.removeSendingMessageFromMessages(message: message)
        self.removeSendingMessageFromSendingQueue(message: message)
        self.addServerMessage(message: message)
    }
    
    private func removeSendingMessageFromMessages(message:TextMessage){
        //#Caution: it only considers text of message for compare! (because sending message has no id)
        let optionalSendingMessageIndex = self.messages.firstIndex { each -> Bool in
            if each.sendingState == .sending, each.text == message.text {
                return true
            }
            return false
        }
        guard let sendingMessageIndex = optionalSendingMessageIndex else{
            return
        }
        self.removeFromMessages(at: sendingMessageIndex)
    }
    
    private func removeSendingMessageFromSendingQueue(message:TextMessage){
        //#Caution: it only considers text of message for compare! (because sending message has no id)
        let optionalSendingMessageIndex = self.sendingQueue.firstIndex { each -> Bool in
            if each.sendingState == .sending, each.text == message.text {
                return true
            }
            return false
        }
        guard let sendingMessageIndex = optionalSendingMessageIndex else{
            return
        }
        self.sendingQueue.remove(at: sendingMessageIndex)
    }
    
    private func addServerMessage(message:TextMessage){
        guard let messageId = message.id else {
            return
        }
        guard !messages.contains(where: { each -> Bool in
            return messageId == each.id
        }) else {
            return
        }
        
        var isInserted = false
        for i in 0..<messages.count {
            guard let eachId = messages[i].id else {
                continue
            }
            if messageId > eachId {
                self.insertToMessages(message, at: i)
                isInserted = true
                break
            }
        }
        
        if !isInserted {
            self.insertToMessages(message, at: nil)
        }
        
    }
    
    private func insertToMessages(_ message:TextMessage,at index:Int?) {
        if let index = index {
            self.messages.insert(message, at: index)
        } else {
            messages.append(message)
        }
        
        if let index=index, index == 0 {
            self.delegate?.updateTableViewAndScrollToTop()
        } else {
            self.delegate?.updateTableView()
        }
        
    }
    private func removeFromMessages(at index:Int) {
        self.messages.remove(at: index)
        self.delegate?.updateTableView()
    }
}

extension MessagesViewModel {
    static func find(chatId:Int,list:[MessagesViewModel])->MessagesViewModel? {
        return list.first(where: { (each) -> Bool in
            if each.chatId == chatId {
                return true
            } else {
                return false
            }
        })
    }
}


protocol MessagesDelegate : class {
    func updateTableViewAndScrollToTop()
    func updateTableView()
}
