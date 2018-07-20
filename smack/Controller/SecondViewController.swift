//
//  SecondViewController.swift
//  smack
//
//  Created by HeinHtet on 7/14/18.
//  Copyright © 2018 HeinHtet. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {

    var drawer : KYDrawerController? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let drawerController = navigationController?.parent as? KYDrawerController {
            drawer = drawerController
            drawer?.drawerWidth =  view.frame.size.width/2
        }
        self.navigationItem.setHidesBackButton(true, animated:true);
        let button1 = UIBarButtonItem(image: UIImage(named: "smackBurger"), style: .plain, target: self, action: #selector(didTapOpenButton(_:)))
        self.navigationItem.leftBarButtonItem  = button1
        title = "SecondView"
        self.view.backgroundColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
    }
    
    @objc func didTapOpenButton(_ sender: UIBarButtonItem) {
        drawer?.setDrawerState(.opened, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
