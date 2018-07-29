//
//  MessageCell.swift
//  smack
//
//  Created by HeinHtet on 7/22/18.
//  Copyright © 2018 HeinHtet. All rights reserved.
//

import UIKit

class MessageCell: UITableViewCell {

    @IBOutlet weak var messageTv: UILabel!
    @IBOutlet weak var timeStampTv: UILabel!
    @IBOutlet weak var userNameTv: UILabel!
    @IBOutlet weak var userImg: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    
    }
    
    func updateCell(message:MessageModel){
        self.messageTv.text = message.messageBody
        self.userNameTv.text = message.userName
        self.userImg.image = UIImage(named : message.userAvatar)
        
        
        guard var isoDate :String = message.timeStamp else {
            return
        }
    
        var endIndex = isoDate.index(isoDate.endIndex, offsetBy: -5)
        isoDate = isoDate.substring(to: endIndex)
        
        let isoFormetter = ISO8601DateFormatter()
        let chatData = isoFormetter.date(from: isoDate.appending("Z"))
        
        let dateFormetter = DateFormatter()
        dateFormetter.dateFormat = "MMM d, h:mm a"
        
        if let finalDate = chatData{
            let finalDate = dateFormetter.string(from: finalDate)
            self.timeStampTv.text = finalDate

        }
        
        
    }

}
