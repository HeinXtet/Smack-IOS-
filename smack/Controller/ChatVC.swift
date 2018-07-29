//
//  ChatVC.swift
//  smack
//
//  Created by HeinHtet on 7/14/18.
//  Copyright © 2018 HeinHtet. All rights reserved.
//

import UIKit

class ChatVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
   
    
    private var typing = false
    @IBOutlet weak var sendBtn : UIButton!
    @IBOutlet weak var messageTableView: UITableView!
    @IBAction func pressed(_ sender: Any) {
        didTapOpenButton(sender as! UIBarButtonItem)
    }
    
    @objc func didTapOpenButton(_ sender: UIBarButtonItem) {
        if let drawerController = navigationController?.parent as? KYDrawerController {
            drawerController.setDrawerState(.opened, animated: true)
        }
    }
    
    @IBOutlet weak var typingLb: UILabel!
    
    @objc func disableShiftKeyboard(_ tap:UITapGestureRecognizer){
        self.view.endEditing(true)
    }
    
    @IBAction func messageBoxChanged(_ sender: Any) {
        print("strat typing")
        if messageField.text == ""{
            typing = false
            stopTyping()
            sendBtn.isHidden = true
        }else{
            startTyping()
            typing = true
            sendBtn.isHidden = false
        }
    }
    @IBAction func editBoxChanged(_ sender: Any) {
      
    }
    
    private func startTyping(){
        if UserAuthServices.instance.isLoggedIn{
            var user = UserDataServices.instance.getUserData()
            var id  = ""
            if let selectedId = MessageService.instance.selctedChannel{
                id = selectedId._id
            }else{
                if MessageService.instance.channel.count > 0 {
                    id = MessageService.instance.channel[0]._id
                }
            }
            SocketService.instance.socket?.emit("startType",
                (user?.name)!,id)
        }
    }
    
    private func stopTyping(){
        if UserAuthServices.instance.isLoggedIn{
            var user = UserDataServices.instance.getUserData()
            var id  = ""
            if let selectedId = MessageService.instance.selctedChannel{
                id = selectedId._id
            }else{
                if MessageService.instance.channel.count > 0 {
                    id = MessageService.instance.channel[0]._id
                }
            }
            SocketService.instance.socket?.emit("stopType",
                                                (user?.name)!,id)
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
        print("CHATVC")
        
    
        if !UserAuthServices.instance.isLoggedIn{
            UserAuthServices.instance.userToken = ""
        }
        
        messageTableView.dataSource = self
        messageTableView.delegate = self
        sendBtn.isHidden = true

        view.bindToKeyboard()
        if let drawerController =
            navigationController?.parent
                as? KYDrawerController {
           drawer = drawerController
        drawer?.drawerWidth = view.frame.size.width/1.5
        
            NotificationCenter.default.addObserver(self, selector: #selector(getChannelSelectedRow), name: NOTIF_CHANNEL_SELECTED, object: nil)
    }
        var tap = UITapGestureRecognizer(target: self, action: #selector(self.disableShiftKeyboard(_:)))
        view.addGestureRecognizer(tap)
        getAllChannel()
        SocketService.instance.getMessageSaved { (messageModel) in            
            if MessageService.instance.selctedChannel?._id == messageModel.channelId{
                MessageService.instance.message.append(messageModel)
                if MessageService.instance.message.count > 0 {
                    self.messageTableView.reloadData()
                    var endIndex = IndexPath(row: MessageService.instance.message.count - 1, section: 0)
                    self.messageTableView.scrollToRow(at: endIndex, at: .bottom, animated: true)
            }           
            }}
        SocketService.instance.typingUser { (typingUsers) in
            var names = ""
            var user = UserDataServices.instance.getUserData()
            var count = 0
            var word = ""
            
            if typingUsers.count > 0 {
                typingUsers.forEach({ (typingUsers,channelId) in
                    if names == ""{
                        if user?.name != typingUsers{
                            names = typingUsers
                        }
                    }else{
                        if user?.name != typingUsers{
                            names = "\(names), \(typingUsers)"
                        }
                    }
                })
                count = count + 1
                if count > 0 {
                    word = "are"
                    if count == 1{
                        word = "is"
                        if names == ""{
                            self.typingLb.text = ""
                        }else{
                            self.typingLb.text = "\(names) \(word) typing message"
                        }
                    }else{
                       // self.typingLb.text = "\(names) \(word) typing message"
                    }
                }
            }else
            {
                self.typingLb.text = ""
            }
        }
    }
    
    
    private func getAllChannel(){
        MessageService.instance.channel.removeAll()
        MessageService.instance.findAllChannel { (isSuccess) in
            if isSuccess{
               self.updateChannel()
                print("get all channel")
            }else{
                print("get all channel error")
            }
        }
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "messageCell", for: indexPath) as? MessageCell{
            cell.updateCell(message: MessageService.instance.message[indexPath.row])
            return cell
        }else{
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MessageService.instance.message.count
    }
    
    
    @objc func getChannelSelectedRow(){
        self.drawer?.setDrawerState(.closed
            , animated: true)
        if UserAuthServices.instance.isLoggedIn
        {
            if let channel = MessageService.instance.selctedChannel{
                print(channel.name)
                updateChannel()
                getAllMesssageFromChannel(id:channel._id)
            }
        }else{
            return
        }
        
    }
    
    @IBOutlet weak var messageField: UITextField!
    
    @IBAction func sendMessagePressed(_ sender: Any) {
        if UserAuthServices.instance.isLoggedIn{
            var id : String = ""
            guard let message = messageField.text , messageField.text != ""else{ return}
            if let selectedId = MessageService.instance.selctedChannel?._id{
               id = selectedId
            }else{
                if let channel : [Channel] = MessageService.instance.channel{
                    if channel.count > 0 {
                        id = channel[0]._id
                    }
                }
            }
            SocketService.instance.sendMessage(messageBody: message, channelId: id) { (isSuccess) in
                if isSuccess{
                    self.messageField.text = ""
                    self.typingLb.text = ""
                    self.view.endEditing(true)
                    self.stopTyping()
                    self.typing = false
                    self.sendBtn.isHidden = true
                    
                }
            }
           
        }
    }
    
    private func getAllMesssageFromChannel(id:String){
        MessageService.instance.getAllMessageFromChannel(channelId:id) { (isSuccess) in
            if isSuccess{
                self.messageTableView.reloadData()
            }
        }
    }
    
    
    private func updateChannel(){
        if UserAuthServices.instance.isLoggedIn{
            if let selectedId = MessageService.instance.selctedChannel{
                updateNavbarTitle(title: "# \(selectedId.name)")
                getAllMesssageFromChannel(id: selectedId._id)
            }else{
                if let channel : [Channel] = MessageService.instance.channel{
                    if channel.count > 0 {
                        print("normal channel \(channel.count)")
                        updateNavbarTitle(title: "# \( channel[0].name)")
                        getAllMesssageFromChannel(id: channel[0]._id)
                    }else{
                        print("normal channel \(channel.count)")
                        updateNavbarTitle(title: "No Channel")
                    }
                }
            }
        }else{
            updateNavbarTitle(title: "Login Please")
        }
    }
    
    private func updateNavbarTitle(title:String){
            self.navigationItem.title = title
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
