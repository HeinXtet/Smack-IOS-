//
//  AddChannelVC.swift
//  smack
//
//  Created by HeinHtet on 7/21/18.
//  Copyright © 2018 HeinHtet. All rights reserved.
//

import UIKit

class AddChannelVC: UIViewController {

    @IBOutlet weak var descriptionField: UITextField!
    @IBOutlet weak var nameField: UITextField!
    @IBAction func closeBtnPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var tap = UITapGestureRecognizer(target: self, action: #selector(tapGesture(_:)))
        self.view.addGestureRecognizer(tap)
    }
    
    @objc func tapGesture(_ reconigser: UITapGestureRecognizer){
        self.dismiss(animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
   

    @IBAction func addChannelPressed(_ sender: Any) {
        guard let name = nameField.text, nameField.text != "" else {
            return
        }
        guard let description = descriptionField.text, nameField.text != "" else {
            return
        }
        SocketService.instance.addChannel(name: name, description: description) { (isSuccess) in
            if isSuccess{
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "add channel"), object: nil)
              self.dismiss(animated: true, completion: nil)
            }
        }
        
    }

}
