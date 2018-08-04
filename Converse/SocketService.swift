//
//  SocketService.swift
//  Converse
//
//  Created by Kareem Ismail on 8/27/17.
//  Copyright © 2017 Whatever. All rights reserved.
//

import UIKit
import SocketIO

class SocketService: NSObject {
    static var instance = SocketService()
    
    override init() {
        super.init()
    }
    
    var socket: SocketIOClient = SocketIOClient(socketURL: URL(string: BASE_URL)!)
    
    func establishConnection(){
        socket.connect()
    }
    
    func terminateConnection(){
        socket.disconnect()
    }
    
    func addChannel(channelName: String, channelDescription: String, completion: @escaping CompletionHandler){
        socket.emit("newChannel", channelName, channelDescription)
        completion(true)
    }
    
    func updateChannels(completion: @escaping CompletionHandler){
        print("got into the update channels")
        socket.on("channelCreated") { (dataArray, ack) in
            guard let channelName = dataArray[0] as? String else {return}
            guard let channelDescription = dataArray[1] as? String else {return}
            guard let channelId = dataArray[2] as? String else {return}
            let newChannel = Channel(name: channelName, description: channelDescription, id: channelId)
            MessagesService.instance.channels.append(newChannel)
            completion(true)
        }
    }
}
