//
//  AppDelegate.swift
//  HelloSinch
//
//  Created by 默司 on 2016/9/20.
//  Copyright © 2016年 默司. All rights reserved.
//

import UIKit
import Fabric
import Crashlytics


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, SINClientDelegate, SINCallClientDelegate {

    var window: UIWindow?
    var client: SINClient?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        Fabric.with([Crashlytics.self])
        
        return true
    }
    
    func clientDidStart(_ client: SINClient!) {
        print("clientDidStart")
        NotificationCenter.default.post(name: .clientDidStart, object: nil)
    }
    
    func clientDidStop(_ client: SINClient!) {
        print("clientDidStop")
    }
    
    func clientDidFail(_ client: SINClient!, error: Error!) {
        print("clientDidFail \(error.localizedDescription)")
    }
    
    func client(_ client: SINCallClient!, didReceiveIncomingCall call: SINCall!) {
        print("didReceiveIncomingCall")
        NotificationCenter.default.post(name: .didReceiveIncomingCall, object: call, userInfo: nil)
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

extension Notification.Name {
    static let clientDidStart = Notification.Name("SINCLIENT_DID_START")
    static let didReceiveIncomingCall = Notification.Name("SINCLIENT_DID_RECEIVE_INCOMING_CALL")
    
}
