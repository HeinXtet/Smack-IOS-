//
//  ChatVC.swift
//  smack
//
//  Created by HeinHtet on 7/14/18.
//  Copyright © 2018 HeinHtet. All rights reserved.
//

import UIKit

class ChatVC: UIViewController {
 
    @IBAction func pressed(_ sender: Any) {
        didTapOpenButton(sender as! UIBarButtonItem)
    }
    
    @objc func didTapOpenButton(_ sender: UIBarButtonItem) {
        if let drawerController = navigationController?.parent as? KYDrawerController {
            drawerController.setDrawerState(.opened, animated: true)
        }
    }
    

    @IBAction func openDrawer(_ sender: Any) {
         drawer?.setDrawerState(.opened, animated: true)
    }
    
    @IBAction func nextPressed(_ sender: Any) {
      navigationController?.pushViewController(SecondViewController(), animated: true)
    }
    
    private var drawer : KYDrawerController? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        if let drawerController =
            parent as? KYDrawerController {
           drawer = drawerController
        drawer?.drawerWidth = view.frame.size.width/1.5
            
        
        
    print("cchate")
            
    }
    }
    
   

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
