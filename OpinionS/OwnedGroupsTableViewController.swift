//
//  OwnedGroupsTableViewController.swift
//  OpinionS
//
//  Created by Florent Remis on 06/02/2015.
//  Copyright (c) 2015 Spersio. All rights reserved.
//

import UIKit

class OwnedGroupsTableViewController: UITableViewController {

    var currentUser: PFUser?
    var listOfOwnedGroups: [String]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        currentUser = PFUser.currentUser()
        
        if currentUser == nil {
            self.tabBarController?.selectedIndex = 0
        } else {
            listOfOwnedGroups = currentUser!["ownedGroups"] as? [String]
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
        
        if listOfOwnedGroups == nil {
            return 0
        } else {
            return listOfOwnedGroups!.count
        }
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ownedGroupCell", forIndexPath: indexPath) as UITableViewCell
        
        var user = listOfOwnedGroups![indexPath.row]
        
        cell.textLabel!.text = user
        
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var groupViewController = segue.destinationViewController as GroupViewController
        if segue.identifier == "ownedGroupSegue" {
            groupViewController.ownedGroup = true
            groupViewController.groupname = (sender as UITableViewCell).textLabel?.text
        }
    }

}
