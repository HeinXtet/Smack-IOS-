//
//  UserDataServices.swift
//  smack
//
//  Created by HeinHtet on 7/15/18.
//  Copyright © 2018 HeinHtet. All rights reserved.
//

import Foundation
class UserDataServices {
    var avatarName :String?
    var userModel : UserModel? = nil
    static let instance = UserDataServices()
    
    func setUserData(userModel:UserModel) {
        self.userModel = userModel
    }
    
    func getUserData()->UserModel?{
        if let model = userModel{
            return model
        }else{
            return nil
        }
    }
    
    
    func setAvatarName(name:String){
        self.avatarName = name
    }
    
}
