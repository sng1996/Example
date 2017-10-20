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
    func didReceiveMessages(messages: [Message], chatId: Int)
}

class MessageManager: NSObject, NOCClientDelegate {
    
    var delegates: NSHashTable<AnyObject> /////private
    //private var client: NOCClient
    //var socket = WebSocket(url: URL(string: "ws://localhost:8080/gameapi")!, protocols: ["chat"])
    var socket = WebSocket(url: URL(string: "ws://fast-basin-97049.herokuapp.com/gameapi")!, protocols: ["chat"])
    
    private var messages: Dictionary<Int, [Message]>
    
    override init() {
        delegates = NSHashTable<AnyObject>.weakObjects()
        //client = NOCClient(userId: User.currentUser.userId)
        messages = [:]
        super.init()
        //client.delegate = self
    }
    
    deinit {
        socket.disconnect(forceTimeout: 0)
        socket.delegate = nil
    }
        
    static let manager = MessageManager()
    
    func play() {
        //client.open()
        socket.delegate = self
        socket.connect()
    }
    
    func logout(vc: ProfileViewController){
        
        let parameters = ["code": 3, "id": myId] as [String : Any]
        do{
            let jsonData = try JSONSerialization.data(withJSONObject: parameters, options: JSONSerialization.WritingOptions()) as NSData
            let jsonString = NSString(data: jsonData as Data, encoding: String.Encoding.utf8.rawValue)! as String
            socket.write(string: jsonString)
            socket.disconnect(forceTimeout: 0, closeCode: 0)
            messages.removeAll()
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "EnterViewController") as! EnterViewController
            vc.present(nextViewController, animated:true, completion:nil)
        }
        catch _{
            print ("JSON Failure")
        }
        
    }
    
    //READ: Output all messages
    func fetchMessages(withChatId chatId: Int, handler: ([Message]) -> Void) {
        if let msgs = messages[chatId] {
            handler(msgs)
        } else {
            var arr = [Message]()
            
            let msg = Message()
            msg.msgType = "Date"
            arr.append(msg)
            
            saveMessages(arr, chatId: chatId)
            
            handler(arr)
        }
    }
    
    func sendMessage(_ message: Message, toChat chat: Chat) {
        let chatId = chat.chatId
        
        saveMessages([message], chatId: chatId)
        
        let parameters = ["code" : 1, "response" : ["message" : message.text, "from_id" : myId, "to_id" : chat.targetId, "chat_id" : chat.chatId]] as [String : Any]
        
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
    
    
    func saveMessages(_ messages: [Message], chatId: Int) { //private
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
        print(text)
        print("RecievedMessage")
        let data: NSData = text.data(using: String.Encoding.utf8)! as NSData
        do {
            let json = try JSONSerialization.jsonObject(with: data as Data, options:.allowFragments) as! [String : AnyObject]
            let code = json["code"] as? Int
            
            if (code == 0){
                let response = json["response"] as? [String: Any]
                let text = response?["message"] as! String
                let senderId = (response?["from_id"] as? Int)!
                let chat_id = (response?["chat_id"] as? Int)!
                let type = "Text"
                let msg = Message()
                msg.senderId = senderId
                msg.msgType = type
                msg.text = text
                msg.isOutgoing = false
                saveMessages([msg], chatId: chat_id)
                
                for delegate in delegates.allObjects {
                    if let d = delegate as? MessageManagerDelegate {
                        d.didReceiveMessages(messages: [msg], chatId: chat_id)
                    }
                }
                
            }else if (code == 4){
                let arr = [MessageDeliveryStatus.Idle, MessageDeliveryStatus.Delivering, MessageDeliveryStatus.Delivered, MessageDeliveryStatus.Failure, MessageDeliveryStatus.Read]
                let response = json["response"] as? [[String: Any]]
                for chat in response!{
                    var msgesArr: [Message] = []
                    let chat_id = chat["chat_id"] as? Int
                    let msges = chat["msges"] as? [[String: Any]]
                    for msg in msges!{
                        let message = Message()
                        message.msgId = String((msg["id"] as? Int)!)
                        message.senderId = (msg["sender_id"] as? Int)!
                        message.text = (msg["text"] as? String)!
                        //message.date = (msg["date"] as? String)!
                        message.deliveryStatus = arr[(msg["status"] as? Int)!]
                        if (message.senderId == myId){
                            message.isOutgoing = true
                        }
                        else{
                            message.isOutgoing = false
                        }
                        msgesArr.append(message)
                    }
                    saveMessages(msgesArr, chatId: chat_id!)
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
