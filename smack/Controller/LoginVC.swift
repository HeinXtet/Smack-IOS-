


//
//  LoginVC.swift
//  smack
//
//  Created by HeinHtet on 7/14/18.
//  Copyright © 2018 HeinHtet. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {

    @IBOutlet weak var loading: UIActivityIndicatorView!
    @IBOutlet weak var loginBtnPressed: UIButton!
    @IBOutlet weak var passField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    
    
    private let authServie = UserAuthServices()
    
    @IBAction func createAccBtnPressed(_ sender: Any) {
        performSegue(withIdentifier: "to_signup", sender: self)
    }
    @IBAction func closeBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    
    @IBAction func loginPressed(_ sender: Any) {
        if let email = emailField.text, let pass = passField.text{
            authServie.login(email: email, pass: pass, completion: ({ isSuccess in
                    if isSuccess{
                        print("loginSUccess")
                        self.authServie.findUser(email:email,completion: { isSuccess in
                            print(isSuccess)
                            NotificationCenter.default.post(name: NOTIF_USER_DID_CHANGE, object: nil)
                            self.closeBtnPressed(self)
                        })
                        print("userotken \(self.authServie.userToken)")
                    }else{
                        
                }
                }
            ))
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    
    }

}
