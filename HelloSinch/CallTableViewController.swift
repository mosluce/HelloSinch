//
//  CallTableViewController.swift
//  HelloSinch
//
//  Created by 默司 on 2016/9/20.
//  Copyright © 2016年 默司. All rights reserved.
//

import UIKit

class CallTableViewController: UITableViewController, SINCallDelegate {

    var currentUserId: String! {
        didSet {
            let manager = SINClientManager.sharedManager
            self.users = manager.users
            self.users.removeValue(forKey: self.currentUserId)
        }
    }
    
    private var users: [String: String]!
    private var alertController: UIAlertController?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.currentUserId = SINClientManager.sharedManager.currentClient!.userId
        
        self.navigationItem.title = SINClientManager.sharedManager.users[currentUserId]
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.didReceiveIncomingCall(_:)), name: .didReceiveIncomingCall, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        SINClientManager.sharedManager.logout()
        
        NotificationCenter.default.removeObserver(self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func didReceiveIncomingCall(_ notification: Notification) {
        let call = notification.object as! SINCall
        call.delegate = self
        self.showIncomingCallView(call)
    }
    
    //正在撥打
    func callDidProgress(_ call: SINCall!) {
        print("callDidProgress")
    }
    
    //接聽
    func callDidEstablish(_ call: SINCall!) {
        self.showTakingView(call)
    }
    
    //結束
    func callDidEnd(_ call: SINCall!) {
        self.hideIncomingCallView()
        self.hideDialingView()
        self.hideTakingView()
    }
    
    func showIncomingCallView(_ call: SINCall) {
        let alertController = UIAlertController(title: "來電提示", message: "\(users[call.remoteUserId]!)的來電", preferredStyle: .actionSheet)
        
        alertController.addAction(UIAlertAction(title: "掛斷", style: .cancel, handler: { (action) in
            call.hangup()
        }))
        alertController.addAction(UIAlertAction(title: "接聽", style: .default, handler: { (action) in
            call.answer()
        }))
        
        self.present(alertController, animated: true, completion: nil)
        self.alertController = alertController
    }
    
    func hideIncomingCallView() {
        alertController?.dismiss(animated: true, completion: nil)
        alertController = nil
    }
    
    func showDialingView(_ call: SINCall) {
        let alertController = UIAlertController(title: "正在撥打", message: "給\(users[call.remoteUserId]!)", preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "掛斷", style: .cancel, handler: { (action) in
            call.hangup()
        }))
        
        self.present(alertController, animated: true, completion: nil)
        self.alertController = alertController
    }
    
    func hideDialingView() {
        alertController?.dismiss(animated: true, completion: nil)
        alertController = nil
    }
    
    func showTakingView(_ call: SINCall) {
        self.hideIncomingCallView()
        self.hideDialingView()
        
        let alertController = UIAlertController(title: "通話中", message: "與\(users[call.remoteUserId]!)", preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "掛斷", style: .cancel, handler: { (action) in
            call.hangup()
        }))
        
        self.present(alertController, animated: true, completion: nil)
        self.alertController = alertController
    }
    
    func hideTakingView() {
        alertController?.dismiss(animated: true, completion: nil)
        alertController = nil
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return users.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath)
        
        // Configure the cell...
        let keys = Array(users.keys)
        let key = keys[indexPath.row]
        
        cell.textLabel?.text = users[key]
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Call to ..."
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if let client = SINClientManager.sharedManager.currentClient {
            let keys = Array(users.keys)
            let userId = keys[indexPath.row]
            
            if let call = client.call().callUser(withId: userId) {
                call.delegate = self
                //self.call = call
                self.showDialingView(call)
            }
        }
        
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
