//
//  MessageModel.swift
//  smack
//
//  Created by HeinHtet on 7/22/18.
//  Copyright © 2018 HeinHtet. All rights reserved.
//

import Foundation
struct MessageModel : Codable{
    var messageBody  : String
    var channelId : String
    var _id : String
    var userName : String
    var userAvatar : String
    var userAvatarColor : String
    var timeStamp : String
}
