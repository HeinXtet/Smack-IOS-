//
//  ChannelCell.swift
//  smack
//
//  Created by HeinHtet on 7/21/18.
//  Copyright © 2018 HeinHtet. All rights reserved.
//

import UIKit

class ChannelCell: UITableViewCell {

    @IBOutlet weak var chanelNameTv: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func updateRow(channel:Channel){
        print("update row ")
        chanelNameTv.text = ("#\(channel.name)")
        chanelNameTv.font = UIFont(name: "HelveticaNeue-Regular", size: 17)

        if MessageService.instance.unReadChannel.count > 0{
            MessageService.instance.unReadChannel.forEach { (channelId) in
                if channel._id == channelId {
                    chanelNameTv.font = UIFont(name: "HelveticaNeue-Regular", size: 2)
                    print("different")
                    chanelNameTv.textColor  = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)

                }
            }
    
        }
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        if selected{
            self.layer.backgroundColor = UIColor(white: 1, alpha: 0.2).cgColor
        }else{
            self.layer.backgroundColor = UIColor.clear.cgColor
        }

    }

}
