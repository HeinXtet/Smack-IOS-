//
//  AvatarCell.swift
//  smack
//
//  Created by HeinHtet on 7/15/18.
//  Copyright © 2018 HeinHtet. All rights reserved.
//

import UIKit

enum AvatarType {
   case dark
   case light
}
class AvatarCell: UICollectionViewCell {
  
    @IBOutlet weak var img:UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.backgroundColor = UIColor.darkGray.cgColor
        self.layer.cornerRadius = 10
        self.clipsToBounds = true
    }
    
    
    
    func updateCell(type:AvatarType,index:Int){
        
        if type == AvatarType.dark{
            self.layer.backgroundColor = UIColor.lightGray.cgColor
            img.image = UIImage(named: "dark\(index)")
        }else{
            self.layer.backgroundColor = UIColor.gray.cgColor
            img.image = UIImage(named: "light\(index)")
        }
    }
    
    
}
