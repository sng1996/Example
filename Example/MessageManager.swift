//
//  MessageManager.swift
//  NoChat-Swift-Example
//
//  Copyright (c) 2016-present, little2s.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//

import Foundation
import NOCProtoKit
import Starscream

protocol MessageManagerDelegate: class {
    func didReceiveMessages(messages: [Message], chatId: String)
}

class MessageManager: NSObject, NOCClientDelegate {
    
    var delegates: NSHashTable<AnyObject> /////private
    private var client: NOCClient
    var socket = WebSocket(url: URL(string: "ws://localhost:8080/gameapi")!, protocols: ["chat"])
    
    private var messages: Dictionary<String, [Message]>
    
    override init() {
        delegates = NSHashTable<AnyObject>.weakObjects()
        client = NOCClient(userId: User.currentUser.userId)
        messages = [:]
        super.init()
        client.delegate = self
        socket.delegate = self
        socket.connect()
    }
    
    deinit {
        socket.disconnect(forceTimeout: 0)
        socket.delegate = nil
    }
        
    static let manager = MessageManager()
    
    func play() {
        client.open()
    }
    
    //READ: Output all messages
    func fetchMessages(withChatId chatId: String, handler: ([Message]) -> Void) {
        if let msgs = messages[chatId] {
            handler(msgs)
        } else {
            var arr = [Message]()
            
            let msg = Message()
            msg.msgType = "Date"
            arr.append(msg)
            
            if chatId == "bot_89757" {
                let msg = Message()
                msg.msgType = "System"
                msg.text = "Welcome to Gothons From Planet Percal #25! Please input `/start` to play!"
                arr.append(msg)
            }
            
            saveMessages(arr, chatId: chatId)
            
            handler(arr)
        }
    }
    
    func sendMessage(_ message: Message, toChat chat: Chat) {
        let chatId = chat.chatId
        
        saveMessages([message], chatId: chatId)
        
        let dict = [
            "from": message.senderId,
            "to": chat.targetId,
            "type": message.msgType,
            "text": message.text,
            "ctype": chat.type
        ]
        
        var target_id = 1
        
        if (myId == 1){
            target_id = 2
        }
        
        let parameters = ["code" : 1, "response" : ["message" : message.text, "from_id" : myId, "to_id" : target_id]] as [String : Any]
        
        //READ: Тут мы посылаем сообщение через сокет
        //client.sendMessage(dict)
        
        do{
            let jsonData = try JSONSerialization.data(withJSONObject: parameters, options: JSONSerialization.WritingOptions()) as NSData
            let jsonString = NSString(data: jsonData as Data, encoding: String.Encoding.utf8.rawValue)! as String
            socket.write(string: jsonString)
        }
        catch _{
            print ("JSON Failure")
        }
    }
    
    func addDelegate(_ delegate: MessageManagerDelegate) {
        delegates.add(delegate)
    }
    
    func removeDelegate(_ delegate: MessageManagerDelegate) {
        delegates.remove(delegate)
    }
    
    //READ: Тут нам пришло сообщение походу
    func clientDidReceiveMessage(_ message: [AnyHashable : Any]) {
        /*guard let senderId = message["from"] as? String,
            let type = message["type"] as? String,
            let text = message["text"] as? String,
            let chatType = message["ctype"] as? String else {
                return;
        }
        
        if type != "Text" || chatType != "bot" {
            return;
        }
        
        let msg = Message()
        msg.senderId = senderId
        msg.msgType = type
        msg.text = text
        msg.isOutgoing = false
        
        let chatId = chatType + "_" + senderId
        
        saveMessages([msg], chatId: chatId)
        
        for delegate in delegates.allObjects {
            if let d = delegate as? MessageManagerDelegate {
                d.didReceiveMessages(messages: [msg], chatId: chatId)
            }
        }*/
    }
    
    func saveMessages(_ messages: [Message], chatId: String) { //private
        var msgs = self.messages[chatId] ?? []
        msgs += messages
        self.messages[chatId] = msgs
    }
    
}

extension MessageManager : WebSocketDelegate {
    public func websocketDidConnect(socket: Starscream.WebSocket) {
        print("Connected")
        let parameters = ["code": 2, "id": myId] as [String : Any]
        do{
            let jsonData = try JSONSerialization.data(withJSONObject: parameters, options: JSONSerialization.WritingOptions()) as NSData
            let jsonString = NSString(data: jsonData as Data, encoding: String.Encoding.utf8.rawValue)! as String
            socket.write(string: jsonString)
        }
        catch _{
            print ("JSON Failure")
        }
    }
    
    public func websocketDidDisconnect(socket: Starscream.WebSocket, error: NSError?) {
        print("Disconnected")
    }
    
    public func websocketDidReceiveMessage(socket: Starscream.WebSocket, text: String) {
        print("RecievedMessage")
        let data: NSData = text.data(using: String.Encoding.utf8)! as NSData
        do {
            let json = try JSONSerialization.jsonObject(with: data as Data, options:.allowFragments) as! [String : AnyObject]
            let response = json["response"] as? [String: Any]
            
            let message = response?["message"] as! String
            
            guard let senderId = "89757" as? String,
                let type = "Text" as? String,
                let text = message as? String,
                let chatType = "bot" as? String else {
                    return;
            }
            
            if type != "Text" || chatType != "bot" {
                return;
            }
            
            let msg = Message()
            msg.senderId = senderId
            msg.msgType = type
            msg.text = text
            msg.isOutgoing = false
            
            let chatId = chatType + "_" + senderId
            
            saveMessages([msg], chatId: chatId)
            
            for delegate in delegates.allObjects {
                if let d = delegate as? MessageManagerDelegate {
                    d.didReceiveMessages(messages: [msg], chatId: chatId)
                }
            }
        }
        catch _{
            print ("JSON Failure")
        }
    }
    
    public func websocketDidReceiveData(socket: Starscream.WebSocket, data: Data) {
        print("RecievedData")
    }
}
