
//
//  ScoketService.swift
//  smack
//
//  Created by HeinHtet on 7/21/18.
//  Copyright © 2018 HeinHtet. All rights reserved.
//

import Foundation
import SocketIO

class SocketService{
    
    
    static let instance = SocketService()
    

    var socketClient : SocketIOClient = SocketIOClient(manager: s, nsp: URL(BASE_URL))
}
