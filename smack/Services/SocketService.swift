//
//  SocketService.swift
//  smack
//
//  Created by HeinHtet on 7/21/18.
//  Copyright © 2018 HeinHtet. All rights reserved.
//

import UIKit
import SocketIO

class SocketService: NSObject {

    static let instance = SocketService()
    let manager = SocketManager(socketURL: URL(string: BASE_URL)!, config: [.log(true), .compress])
    var socket :  SocketIOClient? = nil
    override init() {
        super.init()
        socket = manager.defaultSocket
    }

    func openConnection(){
       socket?.connect()
    }
    
    func closeConnection(){
       socket?.disconnect()
    }
    func addChannel(name:String,description:String,completion : @escaping completionHandler){
        socket?.emit("newChannel", name,description)
        completion(true)
    }
    
    func getChannel(complehandler : @escaping completionHandler){
        print("request channel")
        socket?.on("channelCreated", callback: { (dataArray, emmiter) in
            print("channel \(dataArray.count)" )
            guard let name = dataArray[0] as? String else { return }
            guard let descirption = dataArray[1] as? String else { return }
            guard let id = dataArray[2] as? String else {return}
            let channel = Channel(name: name, _id: id, description: self.description)
            MessageService.instance.channel.append(channel)
            complehandler(true)
        })
    }
    
    func sendMessage(messageBody:String,channelId:String,completion : @escaping completionHandler){
        var userData = UserDataServices.instance.getUserData()
        socket?.emit("newMessage",messageBody,(userData?._id)!,channelId,(userData?.name)!,(userData?.avatarName)!,(userData?.avatarColor)! )
        completion(true)
    }
    
    func getMessageSaved(completion : @escaping (_ message : MessageModel)->Void){
        socket?.on("messageCreated", callback: { (dataArray, callback) in
            guard let messageBody = dataArray[0] as? String else { return }
            guard let userId = dataArray[1] as? String else { return }
            guard let channelId = dataArray[2] as? String else {return}
            guard let userName = dataArray[3] as? String else {return}
            guard let userAvatar = dataArray[4] as? String else {return}            
            guard let userAvatarColor = dataArray[5] as? String else {return}
            guard let id = dataArray[6] as? String else {return}
            guard let timeStamp = dataArray[7] as? String else {return}
           var msg = MessageModel(messageBody: messageBody, channelId: channelId, _id: userId, userName: userName, userAvatar: userAvatar, userAvatarColor: userAvatarColor, timeStamp: timeStamp)
            completion(msg)
        })
    }
    
    
    
    func typingUser(completion : @escaping (_ typingUser: [String:String])->Void){
        self.socket?.on("userTypingUpdate", callback: { (userTyping, akc) in
            guard let typingUser = userTyping[0] as? [String : String] else {return}
            completion(typingUser)
            
        })
        

    }
}
