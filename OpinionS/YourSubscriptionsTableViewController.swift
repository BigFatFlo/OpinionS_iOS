//
//  YourSubscriptionsTableViewController.swift
//  OpinionS
//
//  Created by Florent Remis on 06/02/2015.
//  Copyright (c) 2015 Spersio. All rights reserved.
//

import UIKit

class YourSubscriptionsTableViewController: UITableViewController {

    var currentUser: PFUser?
    var listOfUsers: [String]?
    var listOfUsersToUnsubscribeFrom: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

         self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        currentUser = PFUser.currentUser()
        
        if currentUser == nil {
            self.tabBarController?.selectedIndex = 0
        } else {
            listOfUsers = currentUser!["subscribedUsers"] as? [String]
            self.tableView.reloadData()
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {

        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        if listOfUsers == nil {
            return 0
        } else {
            return listOfUsers!.count
        }
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("subscriptionCell", forIndexPath: indexPath) as UITableViewCell
        
        var user = listOfUsers![indexPath.row]
        
        cell.textLabel!.text = user
        
        
        return cell
    }

    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            listOfUsersToUnsubscribeFrom.append(listOfUsers![indexPath.row])
            listOfUsers!.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        if !listOfUsersToUnsubscribeFrom.isEmpty {
            PFCloud.callFunctionInBackground("subtractSubscriber", withParameters: ["usernames": listOfUsersToUnsubscribeFrom]) {(result: AnyObject!, error: NSError!) -> Void in
                if error == nil {
                    var listChannels = self.currentUser!["channels"] as NSMutableArray
                    for username in self.listOfUsersToUnsubscribeFrom {
                        listChannels.removeObject("User_\(username)")
                    }
                    
                    self.currentUser!["subscribedUsers"] = self.listOfUsers
                    self.currentUser!["channels"] = listChannels
                    
                    self.currentUser!.saveInBackground()
                    
                    self.listOfUsersToUnsubscribeFrom.removeAll()
                    
                } else {
                    
                }
            }
         }
        
    }

}
