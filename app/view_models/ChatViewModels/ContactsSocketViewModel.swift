//
//  ContactsSocketViewModel.swift
//  app
//
//  Created by Amir Hossein on 6/11/19.
//  Copyright © 2019 Hamed.Gh. All rights reserved.
//

import UIKit
import Starscream

class ContactsSocketViewModel: NSObject {
    
    var socket:WebSocket?
    
    weak var delegate : ContactsViewModelNetworkInterface?
    override init() {
        super.init()
        //        self.connect()
    }
    
    deinit {
        print("ContactsSocketViewModel deinit")
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
    
    
    func sendMessage(message:Message){
        
        guard let outputData = try? JSONEncoder().encode(message),
            let outputString = String(bytes: outputData, encoding: .utf8)
            else {
                return
        }
        socket?.write(string: outputString)
        
    }
    
    
    func controlMessageIsReceived(message:Message){
        guard let controlMessage = message.controlMessage else {
            return
        }
        switch controlMessage.type {
        case .ready:
            self.delegate?.tryAgainAllSendingMessages()
            self.fetchContacts()
            
        case .noMoreOldMessages:
            guard let fetchMessagesInput = controlMessage.fetchMessagesInput else {
                break
            }
            self.delegate?.noMoreOldMessagesIsReceived(chatId: fetchMessagesInput.chatId)
        case .ack:
            guard let ackMessage = controlMessage.ackMessage else {
                break
            }
            self.delegate?.ackMessageIsReceived(ackMessage: ackMessage)
        default:
            break
        }
        
    }
    
    
    
    
}

extension ContactsSocketViewModel : ContactsViewModelNetwork {
    
    func sendTextMessage(textMessage:TextMessage) {
        let contactMessage = ContactMessage(textMessages: [textMessage])
        let message = Message(contactMessages: [contactMessage])
        sendMessage(message: message)
    }
    
    func sendAck(ackMessage:AckMessage){
        
        let controlMessage = ControlMessage(ackMessage: ackMessage)
        let message = Message(controlMessage: controlMessage)
        self.sendMessage(message: message)
    }
    
    func fetchContacts(){
        let controlMessage = ControlMessage(type: .fetchContact)
        let message = Message(controlMessage: controlMessage)
        sendMessage(message: message)
    }
    
    func fetchMessages(chatId:Int,beforeId:Int?){
        let fetchMessagesInput = FetchMessagesInput(chatId: chatId, beforeId: beforeId)
        let controlMessage = ControlMessage(type: .fetchMessage, fetchMessagesInput: fetchMessagesInput)
        let message = Message(controlMessage: controlMessage)
        sendMessage(message: message)
    }
}

extension ContactsSocketViewModel : WebSocketDelegate{
    
    func websocketDidConnect(socket: WebSocketClient) {
        print("websocketDidConnect")
//        self.delegate?.socketConnected()
    }
    
    func websocketDidDisconnect(socket: WebSocketClient, error: Error?) {
        print("websocketDidDisconnect")
//        self.delegate?.socketDisConnected()
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
            
        case .control:
            self.controlMessageIsReceived(message: message)
            
        case .contact:
            guard let contactMessages = message.contactMessages else {
                break
            }
            for contactMessage in contactMessages {
                self.delegate?.contactMessageIsReceived(contactMessage: contactMessage)
            }
        }
    }
    
    func websocketDidReceiveData(socket: WebSocketClient, data: Data) {
        print("websocketDidReceiveData")
    }
    
}
