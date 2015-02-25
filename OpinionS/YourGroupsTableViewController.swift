//
//  YourGroupsTableViewController.swift
//  OpinionS
//
//  Created by Florent Remis on 06/02/2015.
//  Copyright (c) 2015 Spersio. All rights reserved.
//

import UIKit

class YourGroupsTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var index = indexPath.row
        
        switch index {
        case 0:
            let cell = tableView.dequeueReusableCellWithIdentifier("joinedGroupsCell", forIndexPath: indexPath) as UITableViewCell
            cell.textLabel!.text = NSLocalizedString("Joined groups", comment:"")
            return cell
        default:
            let cell = tableView.dequeueReusableCellWithIdentifier("ownedGroupsCell", forIndexPath: indexPath) as UITableViewCell
            cell.textLabel!.text = NSLocalizedString("Owned groups", comment:"")
            return cell
        }
        
    }

}
