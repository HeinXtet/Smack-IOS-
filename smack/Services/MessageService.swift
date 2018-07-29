//
//  MessageService.swift
//  smack
//
//  Created by HeinHtet on 7/21/18.
//  Copyright © 2018 HeinHtet. All rights reserved.
//

import Foundation
import Alamofire
class MessageService {
    
    static let instance = MessageService()
    let n = NetworkUtils()
    var message = [MessageModel]()
    var channel = [Channel]()
    var unReadChannel = [String]()
    var channelAdded = false
    var selctedChannel :Channel?
    func findAllChannel(completion: @escaping completionHandler){
        if n.isConnectedToNetwork(){
            let AUTH_HEADER  : [String : String] = [
                "Content-Type" : "application/json; charset=utf-8",
                "Authorization" :"Bearer \(UserAuthServices.instance.userToken)"
            ]
            Alamofire.request(FIND_ALL_CHANNEL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: AUTH_HEADER)
                .responseString { (response) in
                    if response.result.isSuccess{
                        print(response.result.value)
                        var decoder = JSONDecoder()
                        do{
                            var json = try decoder.decode([Channel].self, from: response.data!)
                            self.channel = json
                            print("json str \(self.channel.count)")
                            completion(true)
                        }catch{
                            completion(false)
                            print("decode error")
                        }
                    }else{
                        completion(false)
                        print(response.result.error)
                    }
            }
        }else{
            completion(false)
        }
    }
    
    func addChannel(name:String,description:String,completion : @escaping completionHandler){
        let param = ["name": name ,
                     "description" :description]
        Alamofire.request(ADD_CHANNEL, method: .post, parameters: param, encoding: JSONEncoding.default, headers: AUTH_HEADER)
            .responseString { (response) in
                if response.result.isSuccess{
                    completion(true)
                }else{
                    completion(false)
                }
        }
    }
    
    
    func getAllMessageFromChannel(channelId:String,completion : @escaping completionHandler){
        let AUTH_HEADER  : [String : String] = [
            "Content-Type" : "application/json; charset=utf-8",
            "Authorization" :"Bearer \(UserAuthServices.instance.userToken)"
        ]
        let url = "\(GET_MESSAGE)/\(channelId)"
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: AUTH_HEADER).responseString { (response) in
            if response.result.isSuccess{
                var decoder = JSONDecoder()
                do{
                if let data = response.data{
                    self.message.removeAll()
                        var messages = try decoder.decode([MessageModel].self, from : data)
                        self.message = messages
                    }
                    completion(true)
                }
                catch{
                    
                }
                print("get all message\(response.result.value)")
            }else{
                print("error \(response.error)")
            }
        }
        
    }
    
    
   
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}
