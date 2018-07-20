//
//  UserAuthServices.swift
//  smack
//
//  Created by HeinHtet on 7/14/18.
//  Copyright © 2018 HeinHtet. All rights reserved.
//

import Foundation
import Alamofire

class UserAuthServices{
    private let networkAvaliable = NetworkUtils.instance
    static let instance = UserAuthServices()
    
    var defaults = UserDefaults.standard

    var isLoggedIn : Bool{
        get{
            return defaults.bool(forKey: LOGGED_IN)
        }
        set{
            defaults.set(newValue, forKey: LOGGED_IN)
        }
    }
    

    
    var userToken  : String{
        get{
            return defaults.string(forKey: TOKEN_KEY) as!  String
        }
        set {
            return defaults.set(newValue, forKey: TOKEN_KEY)
        }
    }
    
    var userEmail  : String{
        get{
            return defaults.string(forKey: USER_EMAIL) as! String
        }
        set {
            return defaults.set(newValue, forKey: USER_EMAIL)
        }
    }
    
   
    
    func register(email:String,pass:String,completion : @escaping completionHandler) {
        if networkAvaliable.isConnectedToNetwork(){
            let lowerEmail = email.lowercased()
            let params : [String:Any] = [
                "email" : lowerEmail,
                "password" :pass
            ]
            
            Alamofire.request(REGISTER_URL, method: .post,
                              parameters: params,
                              encoding: JSONEncoding.default,
                              headers: HEADER).responseString(){
                                response in
                                if response.error == nil{
                                    print("Register\(response.result.value)")
                                    completion(true)
                                }else{
                                    completion(false)
                                    debugPrint(response.error as Any)
                                }
                                
            }
        }else{
            print("network fail")
        }
        
    }
    
    func login(email:String,pass:String,completion : @escaping completionHandler) {
        if networkAvaliable.isConnectedToNetwork(){
            let lowerEmail = email.lowercased()
            let params : [String:Any] = [
                "email" : lowerEmail,
                "password" :pass
            ]
            
            print("loginEmail  \(lowerEmail)loginPass   \(pass)" )
            Alamofire.request(
                LOGIN_URL, method: .post, parameters: params, encoding: JSONEncoding.default, headers: HEADER).responseJSON(){
                    response in
                    if response.error == nil{
                        print("login success\(response.result.value)")
                        if let json =  response.result.value as? Dictionary<String,Any>{
                            if let email = json["user"] as? String{
                                self.userEmail = email
                            }
                            if let token = json["token"] as? String{
                                self.userToken = token
                            }
                        }
                        completion(true)
                    }else{
                        completion(false)
                        debugPrint("login Error \(response.error as Any)")
                    }
        }
        }else{
            print("netwok fail")
        }
    }
    
    func findUser(email:String,completion : @escaping completionHandler){
        if networkAvaliable.isConnectedToNetwork(){
            let url = "\(FIND_USER)\(email)"
            let AUTH_HEADER  : [String : String] = [
                "Content-Type" : "application/json; charset=utf-8",
                "Authorization" :"Bearer \(userToken)"
            ]
            Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: AUTH_HEADER).responseString { (response) in
                if response.result.isSuccess{
                    let decoder = JSONDecoder()
                    do{
                        if let data = response.data{
                            let userModel = try decoder.decode(UserModel.self, from: data)
                            UserDataServices.instance.setUserData(userModel: userModel)
                            self.isLoggedIn = true
                            completion(true)
                        }
                    }catch{
                        completion(false)
                        debugPrint("decodeFial \(response.error)")
                    }
                    
                }else{
                  print("error \(response.error)")
                }
            }
        }else{
            
        }
    }
    
    func addUser(name:String,email:String,avatorColor:String,avatorName:String,completion:@escaping completionHandler){
        if networkAvaliable.isConnectedToNetwork(){
            let lowerEmail = email.lowercased()
            let params : [String:Any] = [
                "email" : lowerEmail,
                "name" :name,
                "avatarColor" : avatorColor,
                "avatarName" : avatorName,
            ]
            let AUTH_HEADER  : [String : String] = [
                "Content-Type" : "application/json; charset=utf-8",
                "Authorization" :"Bearer \(userToken)"
            ]
            print("add user token \(userToken)")
            Alamofire.request(ADD_USER, method: .post, parameters: params, encoding: JSONEncoding.default, headers: AUTH_HEADER).responseString() { (response) in
                if response.result.isSuccess {
                    let decoder = JSONDecoder()
                    do{
                        if let data = response.data{
                            var userModel = try decoder.decode(UserModel.self, from: data)
                            UserDataServices.instance.setUserData(userModel: userModel)
                            self.userEmail = email
                            completion(true)
                        }
                    }catch{
                        completion(false)
                        debugPrint("decodeFial \(response.error)")
                    }
            
                
                }else{
                    print("add user error \(response.error)")
                }
        }
    }
    }
    
    
}
