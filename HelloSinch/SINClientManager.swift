//
//  SINClientManager.swift
//  HelloSinch
//
//  Created by 默司 on 2016/9/20.
//  Copyright © 2016年 默司. All rights reserved.
//

import UIKit

class SINClientManager: NSObject {
    static let sharedManager = SINClientManager()

    private weak var appDelegate: AppDelegate!

    var currentClient: SINClient? {
        get {
            return appDelegate.client
        }
    }
    
    private override init() {
        super.init()
        
        self.appDelegate = UIApplication.shared.delegate as! AppDelegate
    }
    
    var users = ["su": "すばる", "rem": "レム", "ram": "ラム", "em": "エミリア"]
    
    //利用 userId 進行 client 初始化
    func client(withUserId userId: String) -> SINClient? {
        if self.appDelegate.client == nil {
            if let client = Sinch.client(withApplicationKey: "<App Key>", applicationSecret: "<App Secret>", environmentHost: "sandbox.sinch.com", userId: userId) {
            
                client.setSupportCalling(true)
                //client.setSupportMessaging(true)
                
                client.enableManagedPushNotifications()
                
                client.delegate = self.appDelegate
                client.call().delegate = self.appDelegate
                //client.messageClient().delegate = self.appDelegate
                
                client.start()
                client.startListeningOnActiveConnection()
            
                self.appDelegate.client = client
            }
        }
        
        return self.appDelegate.client
    }
    
    func logout() {
        if let client = self.appDelegate.client {
            client.stopListeningOnActiveConnection()
            client.terminate()
        }
        
        self.appDelegate.client = nil
    }
    
    func getUserId(withUsername username: String) -> String? {
        let keys = Array(users.keys)
        
        for key in keys {
            if users[key] == username {
                return key
            }
        }
        
        return nil
    }
    
    func getUsername(withUserId userId: String) -> String? {
        return users[userId]
    }
}
