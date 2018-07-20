//
//  RoundedButton.swift
//  smack
//
//  Created by HeinHtet on 7/15/18.
//  Copyright © 2018 HeinHtet. All rights reserved.
//

import UIKit
@IBDesignable

class RoundedButton: UIButton {

    @IBInspectable
    var cornerRadius :CGFloat = 3.3{
        didSet{
            self.layer.cornerRadius = cornerRadius
        }
    }
  
    override func awakeFromNib() {
        setUpView()
    }
    
    override func prepareForInterfaceBuilder() {
      setUpView()
    }
    
    func setUpView() -> Void {
        self.layer.cornerRadius = cornerRadius
    }

}
