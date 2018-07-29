//
//  ChannelVC.swift
//  smack
//
//  Created by HeinHtet on 7/14/18.
//  Copyright © 2018 HeinHtet. All rights reserved.
//

import UIKit

class ChannelVC: UIViewController ,UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MessageService.instance.channel.count
    }
    
    private var drawerController : KYDrawerController?
    
    @IBAction func createChannelPressed(_ sender: Any) {
        var addChannelVC = AddChannelVC()
        addChannelVC.modalPresentationStyle = .custom
        present(addChannelVC, animated: true, completion: nil)
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ChannelCell",for:indexPath
            )as? ChannelCell{
            if MessageService.instance.channel.count > 0{
                cell.updateRow(channel: MessageService.instance.channel[indexPath.row])
            }
            return cell
        }
        return UITableViewCell()
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      var channel =   MessageService.instance.channel[indexPath.row]
        MessageService.instance.selctedChannel = channel
        
        
        if MessageService.instance.unReadChannel.count > 0{
            MessageService.instance.unReadChannel = MessageService.instance.unReadChannel.filter{$0 != channel._id}
            var path = IndexPath(item: indexPath.row, section: 0)
            self.channelsTableView.reloadRows(at: [path], with: .none)
            self.channelsTableView.selectRow(at: indexPath, animated: true, scrollPosition:  .none)
            
        }
        
        NotificationCenter.default.post(name:NOTIF_CHANNEL_SELECTED, object: indexPath.row)

    }
    

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    @IBOutlet weak var channelsTableView: UITableView!
    @IBOutlet weak var userName: UIButton!
    @IBOutlet weak var userImg: UIImageView!
    @IBOutlet weak var loginBtn: UIButton!
    @IBAction func loginBtnPressed(_ sender: Any) {
        if UserAuthServices.instance.isLoggedIn {
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
        
        
        print("channelVC")
        
        if let controller = parent as? KYDrawerController{
            self.drawer = controller
        }
        
        channelsTableView.delegate = self
        channelsTableView.dataSource = self
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
        getAllChannel()
        channelAdded()
        
        SocketService.instance.getMessageSaved { (messageModel) in
            if messageModel._id != MessageService.instance.selctedChannel?._id{
                MessageService.instance.unReadChannel.append(messageModel.channelId)
                print("different channel")
                self.channelsTableView.reloadData()
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("channel vc view did appear")
        NotificationCenter.default.addObserver(self, selector: #selector(self.userDidChanged), name: NOTIF_USER_DID_CHANGE, object: nil)
    

    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }

    
  @objc  func channelAdded(){
        print("get Channel Added")
        SocketService.instance.getChannel { (success) in
            if success{
                self.channelsTableView.reloadData()
            }
        }
    }

    
    private func getAllChannel(){
        MessageService.instance.findAllChannel { (isSuccess) in
            if isSuccess{
                print("get all channel")

                self.channelsTableView.reloadData()
            }else{
                print("get all channel error")
            }
        }
    }
    
    
    @objc func userDidChanged(){
        print("user did change")
        if UserAuthServices.instance.isLoggedIn{
            if let userModel = UserDataServices.instance.getUserData(){
                userImg.image = UIImage(named: userModel.avatarName)
                userName.setTitle(userModel.name, for: .normal)
                userImg.backgroundColor = UIColor(named: userModel.avatarColor)
                MessageService.instance.channel.removeAll()
                if !MessageService.instance.channelAdded{
                    getAllChannel()
                    MessageService.instance.channelAdded = true
                }
            }else{
                userImg.image = UIImage(named: "menuProfileIcon")
                userName.setTitle("Login", for: .normal)
                userImg.backgroundColor = UIColor.clear
                MessageService.instance.channel.removeAll()
                channelsTableView.reloadData()
            }
        }else{
            MessageService.instance.channel.removeAll()
            channelsTableView.reloadData()
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
