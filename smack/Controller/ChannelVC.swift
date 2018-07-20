//
//  ChannelVC.swift
//  smack
//
//  Created by HeinHtet on 7/14/18.
//  Copyright © 2018 HeinHtet. All rights reserved.
//

import UIKit

class ChannelVC: UIViewController {

    @IBOutlet weak var userName: UIButton!
    @IBOutlet weak var userImg: UIImageView!
    @IBOutlet weak var loginBtn: UIButton!
    @IBAction func loginBtnPressed(_ sender: Any) {
        if UserAuthServices.instance.isLoggedIn {
            //go to profile view
            var profile = ProfileVC()
            profile.modalPresentationStyle = .custom
            present(profile, animated: true, completion: nil)
        }else{
            performSegue(withIdentifier: TO_LOGIN, sender: self)
        }
    }
    
    @IBAction func prepareForUnWind(segue:UIStoryboardSegue){
        
    }
    

    
    var drawer :KYDrawerController? = nil
    override func viewDidLoad() {
        super.viewDidLoad()
        print("view did loa")
        
        if UserAuthServices.instance.isLoggedIn{
        UserAuthServices.instance.findUser(email:UserAuthServices.instance.userEmail) { (response) in
                if response{
                    print("find success")
                    self.userDidChanged()
                }else{
                    print("user not found")
                }
            }
        }


    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("channel vc view did appear")

    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("channel vc v view will appear")
        NotificationCenter.default.addObserver(self, selector: #selector(self.userDidChanged), name: NOTIF_USER_DID_CHANGE, object: nil)
    
    }

    
    
    @objc func userDidChanged(){
        print("user did change")
        if UserAuthServices.instance.isLoggedIn{
            if let userModel = UserDataServices.instance.getUserData(){
                userImg.image = UIImage(named: userModel.avatarName)
                userName.setTitle(userModel.name, for: .normal)
                userImg.backgroundColor = UIColor(named: userModel.avatarColor)
            }else{
                userImg.image = UIImage(named: "menuProfileIcon")
                userName.setTitle("Login", for: .normal)
                userImg.backgroundColor = UIColor.clear
            }
        }else{
            userImg.image = UIImage(named: "menuProfileIcon")
            userName.setTitle("Login", for: .normal)
            userImg.backgroundColor = UIColor.clear
        }
    }
    
    @IBAction func goAnother(_ sender: Any) {
        print("go to second")
        if let drawer = parent as? KYDrawerController{
            let navController = drawer.mainViewController
        as! UINavigationController?
            print("go to second")
            navController?.pushViewController(SecondViewController(), animated: true)
            drawer.setDrawerState(.closed, animated: true)
        }
    
}
    
    
    private func goAnotherVC(){
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newVC: SecondViewController = storyboard.instantiateViewController(withIdentifier: "SecondVC") as! SecondViewController // view to set
        let drawerController = self.navigationController?.parent as? KYDrawerController
        let navController = UINavigationController.init(rootViewController: newVC)
        drawerController?.mainViewController=navController
        drawerController?.setDrawerState(KYDrawerController.DrawerState.closed, animated: true)
    }
    
    
override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
