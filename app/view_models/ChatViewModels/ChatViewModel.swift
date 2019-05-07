//
//  ChatViewModel.swift
//  KindnessWallChat
//
//  Created by Amir Hossein on 3/11/19.
//  Copyright © 2019 Amir Hossein. All rights reserved.
//

import UIKit
import Starscream
import KeychainSwift

class ChatViewModel: NSObject {
    
    var socket:WebSocket?
    var userId :Int
    var allChats = [MessagesViewModel]()
    
    weak var delegate : ChatViewModelProtocol?
    
    override init() {
        let userId = Int(KeychainSwift().get(AppConst.KeyChain.USER_ID) ?? "")
        self.userId = userId ?? -1
        super.init()
        self.connect()
    }
    
    deinit {
        print("ChatViewModel deinit")
    }
    
    func connect() {
        guard let url = URL(string: URIs().chat) else {
            return
        }
        guard AppDelegate.me().isUserLogedIn() else {
            return
        }
        var request = URLRequest(url: url)
        request = APICall.setRequestHeader(request: request)
        socket = WebSocket(request: request)
        socket?.delegate = self
        socket?.connect()
    }
    
    private func sendTextMessage(textMessage:TextMessage) {
        let message = Message(textMessages: [textMessage])
        sendMessage(message: message)
    }
    private func sendMessage(message:Message){
        
        guard let outputData = try? JSONEncoder().encode(message),
            let outputString = String(bytes: outputData, encoding: .utf8)
            else {
                return
        }
        socket?.write(string: outputString)
        
    }
    
    func sendAck(textMessage:TextMessage){
        guard textMessage.receiverId == userId, textMessage.ack == false else {
            return
        }
        guard let messageId=textMessage.id else {
            return
        }
        let ackMessage = AckMessage(messageId: messageId)
        let controlMessage = ControlMessage(ackMessage: ackMessage)
        let message = Message(controlMessage: controlMessage)
        self.sendMessage(message: message)
    }
    
    func addMessage(message:TextMessage,isSending:Bool) -> MessagesViewModel {
        
        let messagesViewModel : MessagesViewModel = {
            if let messagesViewModel = MessagesViewModel.find(chatId: message.chatId, list: self.allChats) {
                return messagesViewModel
            } else {
                let messagesViewModel = MessagesViewModel(userId: self.userId, chatId: message.chatId)
                self.allChats.append(messagesViewModel)
                return messagesViewModel
            }
        }()
        
        self.addMessage(message: message, isSending: isSending, messagesViewModel: messagesViewModel)
        
        return messagesViewModel
    }
    
    func addMessage(message:TextMessage,isSending:Bool,messagesViewModel:MessagesViewModel){
        
        messagesViewModel.addMessage(message: message,isSending: isSending)
        self.delegate?.reload()
        
    }
    
    
    func textMessageIsReceived(message:Message){
        guard let textMessages = message.textMessages else {
            return
        }
        for textMessage in textMessages {
            let _ = self.addMessage(message: textMessage, isSending: false)
            self.sendAck(textMessage: textMessage)
        }
        
    }
    
    
    func controlMessageIsReceived(message:Message){
        guard let controlMessage = message.controlMessage else {
            return
        }
        switch controlMessage.type {
        case .ready:
            self.tryAgainAllSendingMessages()
            self.fetchMessages()
            
        case .noMoreOldMessages:
            guard let fetchMoreMessagesInput = controlMessage.fetchMoreMessagesInput else {
                break
            }
            self.noMoreOldMessagesIsReceived(chatId: fetchMoreMessagesInput.chatId)
        case .ack:
            guard let ackMessage = controlMessage.ackMessage else {
                break
            }
            self.ackMessageIsReceived(ackMessage: ackMessage)
        default:
            break
        }
        
    }
    
    func fetchMessages(){
        let controlMessage = ControlMessage(type: .fetch)
        let message = Message(controlMessage: controlMessage)
        sendMessage(message: message)
    }
    
    func fetchMoreMessages(chatId:Int,beforeId:Int?){
        let fetchMoreMessagesInput = FetchMoreMessagesInput(chatId: chatId, beforeId: beforeId)
        let controlMessage = ControlMessage(type: .fetchMore, fetchMoreMessagesInput: fetchMoreMessagesInput)
        let message = Message(controlMessage: controlMessage)
        sendMessage(message: message)
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
                self.sendTextMessage(textMessage: eachMessage)
            }
        }
    }
    
    
}

extension ChatViewModel : WebSocketDelegate{
    
    func websocketDidConnect(socket: WebSocketClient) {
        print("websocketDidConnect")
        self.delegate?.socketConnected()
    }
    
    func websocketDidDisconnect(socket: WebSocketClient, error: Error?) {
        print("websocketDidDisconnect")
        self.delegate?.socketDisConnected()
        connect()
    }
    
    func websocketDidReceiveMessage(socket: WebSocketClient, text: String) {
        guard let input = text.data(using: .utf8) else {
            return
        }
        guard let message = try? JSONDecoder().decode(Message.self, from: input) else {
            return
        }
        
        switch message.type {
        case .text:
            self.textMessageIsReceived(message: message)
            
        case .control:
            self.controlMessageIsReceived(message: message)
        }
    }
    
    func websocketDidReceiveData(socket: WebSocketClient, data: Data) {
        print("websocketDidReceiveData")
    }
}

extension ChatViewModel : MessagesViewControllerDelegate {
    
    func writeMessage(text:String,messagesViewModel:MessagesViewModel){
        
        let message = TextMessage(text: text, senderId: self.userId, chatId: messagesViewModel.chatId)
        
        self.addMessage(message: message, isSending: true, messagesViewModel: messagesViewModel)
        
        self.sendTextMessage(textMessage: message)
        
    }
    
    func loadMoreMessages(chatId:Int,beforeId:Int?){
        self.fetchMoreMessages(chatId: chatId, beforeId: beforeId)
    }
}

extension ChatViewModel : StartNewChatProtocol {
    
    func writeMessage(text:String,chatId:Int)->MessagesViewModel{
        
        let message = TextMessage(text: text, senderId: self.userId, chatId: chatId)
        
        let messagesViewModel = self.addMessage(message: message, isSending: true)
        
        self.sendTextMessage(textMessage: message)
        
        return messagesViewModel
    }
    
    func getMessagesViewControllerDelegate() -> MessagesViewControllerDelegate {
        return self
    }
}

protocol ChatViewModelProtocol : class {
    func reload()
    func socketConnected()
    func socketDisConnected()
}

protocol StartNewChatProtocol : class {
    func writeMessage(text:String,chatId:Int)->MessagesViewModel
    func getMessagesViewControllerDelegate()->MessagesViewControllerDelegate
}
