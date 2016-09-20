//
//  ViewController.swift
//  HelloSinch
//
//  Created by 默司 on 2016/9/20.
//  Copyright © 2016年 默司. All rights reserved.
//

import UIKit
import Crashlytics

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func login(_ sender: AnyObject) {
        let manager = SINClientManager.sharedManager
        
        if let username = (sender as? UIButton)?.title(for: .normal), let userId = manager.getUserId(withUsername: username), manager.client(withUserId: userId) != nil {
        
            //開始觀察
            NotificationCenter.default.addObserver(self, selector: #selector(self.clientDidStart(_:)), name: .clientDidStart, object: nil)
        }
    }
    
    @IBAction func crashButtonTapped(sender: AnyObject) {
        Crashlytics.sharedInstance().crash()
    }

    
    func clientDidStart(_ notification: Notification) {
        self.performSegue(withIdentifier: "Login", sender: self)
        
        NotificationCenter.default.removeObserver(self)
    }

}

