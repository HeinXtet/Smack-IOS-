//
//  ProfileVC.swift
//  smack
//
//  Created by HeinHtet on 7/19/18.
//  Copyright © 2018 HeinHtet. All rights reserved.
//

import UIKit

protocol LogoutChange {
    func userLogout()
}

class ProfileVC: UIViewController {

    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var userEmailTv: UILabel!
    @IBOutlet weak var userNameTv: UILabel!
    @IBOutlet weak var profileIv: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()

        if let userData =  UserDataServices.instance.getUserData(){
            userNameTv.text = userData.name
            userEmailTv.text = userData.email
            profileIv.image = UIImage(named: userData.avatarName)
            
        }
    }
    
    
    private func setupView(){
        var tap = UITapGestureRecognizer(target: self, action: #selector(closeModel(_:)))
        bgView.addGestureRecognizer(tap)
    }

    @objc func closeModel(_ reconiger: UITapGestureRecognizer){
    dismiss(animated: true, completion: nil)
    }
    
    @IBAction func logoutPressed(_ sender: Any) {
        UserAuthServices.instance.isLoggedIn = false
        UserDataServices.instance.setUserData(userModel: UserModel(avatarColor: "", avatarName: "", email: "", name: "<#T##String#>", _id: ""))
        UserAuthServices.instance.userToken = ""
        NotificationCenter.default.post(name: NOTIF_USER_DID_CHANGE, object: nil)
        closePressed(self)

        
    }
 
    @IBAction func closePressed(_ sender: Any) {
            dismiss(animated: true, completion: nil)
    }
    
}
