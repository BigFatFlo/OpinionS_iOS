//
//  JoinedGroupsTableViewController.swift
//  OpinionS
//
//  Created by Florent Remis on 06/02/2015.
//  Copyright (c) 2015 Spersio. All rights reserved.
//

import UIKit

class JoinedGroupsTableViewController: UITableViewController {

    var currentUser: PFUser?
    var listOfJoinedGroups: [String]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        currentUser = PFUser.currentUser()
        
        if currentUser == nil {
            self.tabBarController?.selectedIndex = 0
        } else {
            listOfJoinedGroups = currentUser!["joinedGroups"] as? [String]
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
        
        if listOfJoinedGroups == nil {
            return 0
        } else {
            return listOfJoinedGroups!.count
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("joinedGroupCell", forIndexPath: indexPath) as UITableViewCell
        
        var group = listOfJoinedGroups![indexPath.row]
        
        cell.textLabel!.text = group
        
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var groupViewController = segue.destinationViewController as GroupViewController
        if segue.identifier == "joinedGroupSegue" {
            groupViewController.joinedGroup = true
            groupViewController.groupname = (sender as UITableViewCell).textLabel?.text
        }
    }

}
