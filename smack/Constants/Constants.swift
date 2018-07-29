//
//  File.swift
//  smack
//
//  Created by HeinHtet on 7/14/18.
//  Copyright © 2018 HeinHtet. All rights reserved.
//

import Foundation

typealias completionHandler = (_ success :Bool)->()

let BASE_URL = "http://localhost:3005/v1/"
//let BASE_URL = "https://deevdchat.herokuapp.com/v1/"
let REGISTER_URL = "\(BASE_URL)account/register"
let LOGIN_URL =  "\(BASE_URL)account/login"
let ADD_USER = "\(BASE_URL)user/add"
let FIND_USER = "\(BASE_URL)user/byEmail/"
let FIND_ALL_CHANNEL = "\(BASE_URL)channel"
let ADD_CHANNEL = "\(BASE_URL)channel/add"
let GET_MESSAGE = "\(BASE_URL)message/byChannel"

// header
let HEADER : [String : String] = [
    "Content-Type" : "application/json; charset=utf-8"
]

let AUTH_HEADER  : [String : String] = [
    "Content-Type" : "application/json; charset=utf-8",
    "Authorization" : "Bearer \(UserAuthServices.instance.userToken)"
]

// notifiation

let NOTIF_USER_DID_CHANGE = Notification.Name("Notif User Data Changed")
let NOTIF_CHANNEL_SELECTED = Notification.Name("channel selected")


//segue
let TO_LOGIN = "to_login"
let TO_SIGNUP = "to_signup"
let UNWIND = "un_wind"
let TO_AVATOR = "to_avator_vc"

//auth
let LOGGED_IN = "loggedIn"
let TOKEN_KEY =  "token"
let USER_EMAIL = "email"

