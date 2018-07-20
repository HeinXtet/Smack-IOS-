//
//  CircleImageView.swift
//  smack
//
//  Created by HeinHtet on 7/15/18.
//  Copyright © 2018 HeinHtet. All rights reserved.
//

import UIKit

class CircleImageView: UIImageView {

    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUpView()
    }
    
    private func setUpView(){
        self.layer.cornerRadius = self.frame.size.width / 2
        self.clipsToBounds = true
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
