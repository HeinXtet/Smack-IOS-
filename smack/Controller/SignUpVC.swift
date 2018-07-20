//
//  SignUpVC.swift
//  smack
//
//  Created by HeinHtet on 7/14/18.
//  Copyright © 2018 HeinHtet. All rights reserved.
//

import UIKit

class SignUpVC: UIViewController {
    @IBOutlet weak var userImg : UIImageView!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var userNameField: UITextField!
    
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    private var imgBgColor : UIColor? = nil
    
    var imageName = "profileDefault"
    var bgColor = "[10,11,31]"
    
    @IBAction func closeBtnPressed(_ sender: Any) {
        performSegue(withIdentifier: UNWIND, sender: nil)
    }
    @IBOutlet weak var chooseImgBgColorPressed: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
    }
    
    func setUpView(){
        self.loadingIndicator.isHidden = true
        let tap = UIGestureRecognizer(target: self, action: #selector(SignUpVC.handleTap))
        //self.view.addGestureRecognizer(tap)
    }
    
    
    @objc func handleTap(){
        self.view.endEditing(true)
    }
    
    @IBAction func bgChoossePressed(_ sender: Any) {
        let r  = CGFloat(arc4random_uniform(255)) / 255
        let g  = CGFloat(arc4random_uniform(255)) / 255
        let b  = CGFloat(arc4random_uniform(255)) / 255
        imgBgColor = UIColor(red: r, green: g, blue: b, alpha: 1)
        bgColor = "[\(r),\(g),\(b),1]"
        UIView.animate(withDuration: 0.2) {
            self.userImg.backgroundColor =  self.imgBgColor
        }
    
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if UserDataServices.instance.avatarName != nil {
            let img = UserDataServices.instance.avatarName
            userImg.image = UIImage(named: img!)
            self.imageName = img!
            if (img?.contains("light"))! && imgBgColor == nil{
                self.userImg.backgroundColor = UIColor.lightGray
            }
        }
    }

    @IBAction func chooseAvatar(_ sender: Any) {
        performSegue(withIdentifier: TO_AVATOR, sender: self)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBOutlet weak var createAccountPressed: RoundedButton!
    
    @IBAction func createAccPressed(_ sender: Any) {
        loadingIndicator.isHidden = false
        loadingIndicator.startAnimating()
        guard let userEmail = emailField.text, emailField.text != "" else {
            return
        }
        guard let userPass = passwordField.text, passwordField.text != "" else {
            return
        }
        UserAuthServices.instance.register(email: userEmail, pass: userPass, completion: ({ (success) in
            if success{
                print("register success")
                UserAuthServices.instance.login(email: userEmail, pass: userPass, completion: { (ok) in
                    if ok{
                        print("login success")
                        UserAuthServices.instance.addUser(name: self.userNameField.text!, email: userEmail, avatorColor: self.bgColor, avatorName: self.imageName, completion: { (success) in
                            if success{
                                print("add user success")
                                if  let userModel =  UserDataServices.instance.getUserData(){
                                   self.loadingIndicator.isHidden = true
                                    self.closeBtnPressed(self)
                                    UserAuthServices.instance.isLoggedIn  = true
                                    NotificationCenter.default.post(name: NOTIF_USER_DID_CHANGE, object: nil)
                                }
                                
                        }else{
                                self.loadingIndicator.isHidden = true
                                print("add user error ")
                            }
                         
                        })
                    }else {
                        self.loadingIndicator.isHidden = true
                        print("login error")
                    }
                })
            }else{
                self.loadingIndicator.isHidden = true
            }
        }))
    }
}
