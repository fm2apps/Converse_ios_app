//
//  ChannelViewController.swift
//  Converse
//
//  Created by Kareem Ismail on 8/16/17.
//  Copyright © 2017 Whatever. All rights reserved.
//

import UIKit

class ChannelViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var channelsTableView: UITableView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var loginButton: UIButton!
    @IBAction func prepareForUnwind(segue: UIStoryboardSegue){}
    override func viewDidLoad() {
        super.viewDidLoad()
        channelsTableView.delegate = self
        channelsTableView.dataSource = self
        self.revealViewController().rearViewRevealWidth = self.view.frame.size.width - 60
        NotificationCenter.default.addObserver(self, selector: #selector(userDataChanged), name: NOTIFY_USER_DATA_CHANGE, object: nil)
//        SocketService.instance.updateChannels { (success) in
//            if success {
//                self.channelsTableView.reloadData()
//            }
//        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        reloadData()
        setupUserData()
    }

    @IBAction func addChannelButtonPressed(_ sender: Any) {
        
        if AuthService.instance.isLoggedIn {
            let addChannel = AddChannelViewController()
            addChannel.modalPresentationStyle = .custom
            present(addChannel, animated: true, completion: nil)
        }
        
    }

    @IBAction func loginButtonPressed(_ sender: Any) {
        
        if AuthService.instance.isLoggedIn {
            let profile = ProfileViewController()
            profile.modalPresentationStyle = .custom
            present(profile, animated: true, completion: nil)
        }
            
        else {
            performSegue(withIdentifier: TO_LOGIN , sender:nil)
        }
        
    }
    
   @objc func userDataChanged(){
        print("got into user data changed")
        setupUserData()
    }
    
    func setupUserData(){
        if AuthService.instance.isLoggedIn {
            loginButton.setTitle(UserDataService.instance.name, for: .normal)
            profileImage.image = UIImage(named: UserDataService.instance.avatarName)
            profileImage.backgroundColor = UserDataService.instance.returnUIColor(components: UserDataService.instance.avatarColor)
            SocketService.instance.updateChannels { (success) in
                if success {
                    self.channelsTableView.reloadData()
                }
            }
        }
        else {
            loginButton.setTitle("Login", for: .normal)
            profileImage.image = UIImage(named:"menuProfileIcon")
            profileImage.backgroundColor = UIColor.clear
            channelsTableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = channelsTableView.dequeueReusableCell(withIdentifier: "channelCell", for: indexPath) as? ChannelCell {
            let channel = MessagesService.instance.channels[indexPath.row]
            cell.configureCell(channel: channel)
            return cell
            
        } else {
            return UITableViewCell()
        }
    }


    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if AuthService.instance.isLoggedIn{
            return MessagesService.instance.channels.count
        }
        else{
            return 0
        }
    }
    func reloadData(){
        if AuthService.instance.isLoggedIn{
        MessagesService.instance.getAllChannels(completion: { (success) in
            if success {
                self.channelsTableView.reloadData()
            }
        })
        }
    }
    
    
    
    
    
    
    
    
    
    
}
