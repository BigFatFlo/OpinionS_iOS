//
//  GroupViewController.swift
//  OpinionS
//
//  Created by Florent Remis on 19/01/2015.
//  Copyright (c) 2015 Spersio. All rights reserved.
//

import UIKit

class GroupViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var groupNameTitle: UINavigationItem!
    @IBOutlet weak var numberOfMembers: UILabel!
    @IBOutlet weak var memberOrOwner: UILabel!
    @IBOutlet weak var listOfOwnersButton: UIButton!
    @IBOutlet weak var addOwnerLabel: UILabel!
    @IBOutlet weak var addOwnerField: UITextField!
    @IBOutlet weak var addOwnerButton: UIButton!
    @IBOutlet weak var addOwnerErrorMessageLabel: UILabel!
    @IBOutlet weak var listOfMembersButton: UIButton!
    @IBOutlet weak var leaveGroupLabel: UILabel!
    @IBOutlet weak var leaveGroupButton: UIButton!
    @IBOutlet weak var leaveGroupErrorMessageLabel: UILabel!
    
    var joinedGroup = false
    var ownedGroup = false
    var groupname: String?
    var currentUser: PFUser?
    var listOfOwners: [String]?
    var listOfMembers: [String]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        removeView(numberOfMembers)
        removeView(memberOrOwner)
        removeView(listOfOwnersButton)
        removeView(addOwnerLabel)
        removeView(addOwnerField)
        removeView(addOwnerButton)
        removeView(addOwnerErrorMessageLabel)
        removeView(listOfMembersButton)
        removeView(leaveGroupLabel)
        removeView(leaveGroupButton)
        removeView(leaveGroupErrorMessageLabel)
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        currentUser = PFUser.currentUser()
        
        if currentUser != nil {
            
            leaveGroupLabel.text = NSLocalizedString("leave group", comment:"")
            
            PFCloud.callFunctionInBackground("groupData", withParameters: ["groupname": groupname!, "username": currentUser!.username]) {
                (data: AnyObject!, error: NSError!) -> Void in
                if error == nil {
                    self.groupNameTitle.title = self.groupname
                    var isOwner = data["isOwner"] as Bool
                    var isMember = data["isMember"] as Bool
                    
                    if isOwner {
                        
                        showView(self.numberOfMembers)
                        showView(self.memberOrOwner)
                        showView(self.listOfOwnersButton)
                        showView(self.addOwnerLabel)
                        showView(self.addOwnerField)
                        showView(self.addOwnerButton)
                        showView(self.listOfMembersButton)
                        
                        if isMember {
                            self.memberOrOwner.text = NSLocalizedString("you are an owner and a member", comment:"")
                            showView(self.leaveGroupLabel)
                            showView(self.leaveGroupButton)
                        } else {
                            self.memberOrOwner.text = NSLocalizedString("you are an owner", comment:"")
                        }
                        
                        self.numberOfMembers.text = NSLocalizedString("number of members:", comment:"") + String(data["nbrMembers"] as Int)
                        
                        self.listOfOwners = data["owners"] as? [String]
                        self.listOfMembers = data["members"] as? [String]
                        
                    } else if isMember {
                        
                        showView(self.numberOfMembers)
                        showView(self.memberOrOwner)
                        showView(self.listOfOwnersButton)
                        showView(self.leaveGroupLabel)
                        showView(self.leaveGroupButton)
                        self.memberOrOwner.text = NSLocalizedString("you are a member", comment:"")
                        
                        self.numberOfMembers.text = NSLocalizedString("number of members:", comment:"") + String(data["nbrMembers"] as Int)
                        
                        self.listOfOwners = data["owners"] as? [String]
                        
                    } else {
                        
                        showView(self.memberOrOwner)
                        self.memberOrOwner.text = NSLocalizedString("not member nor owner", comment:"")
                        self.memberOrOwner.textColor = UIColor.redColor()
                        
                    }
                    
                } else {
                    showView(self.memberOrOwner)
                    self.memberOrOwner.text = NSLocalizedString("unable to load group data", comment:"")
                    self.memberOrOwner.textColor = UIColor.redColor()
                }
            }
        
        } else {
            self.tabBarController?.selectedIndex = 0
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func listOfOwnersButton(sender: AnyObject) {
        
        var done: ActionStringDoneBlock =
        {(picker: ActionSheetStringPicker!, selectedIndex: Int, selectedValue: AnyObject!) -> Void in
        }
        
        var cancel: ActionStringCancelBlock = {(picker: ActionSheetStringPicker!) -> Void in
        }
        
        var groupPicker = ActionSheetStringPicker(title: NSLocalizedString("Owners", comment:""), rows: listOfOwners!, initialSelection: 0,
            doneBlock: done,
            cancelBlock: cancel,
            origin: sender)
        
        groupPicker.showActionSheetPicker()
        
    }
    
    @IBAction func addOwnerButton(sender: AnyObject) {
        
        if !addOwnerField.text.isEmpty {
        
            removeView(leaveGroupErrorMessageLabel)
            removeView(addOwnerErrorMessageLabel)
            addOwnerErrorMessageLabel.textColor = UIColor.redColor()
            
            PFCloud.callFunctionInBackground("addOwner", withParameters: ["groupname": groupname!, "username": currentUser!.username, "newOwnerUsername": addOwnerField.text]) {
                (object: AnyObject!, error: NSError!) -> Void in
                if error == nil {
                    var result = object as Int
                    
                    switch result {
                    case -4:
                        
                        self.addOwnerErrorMessageLabel.text = NSLocalizedString("not owner", comment:"")
                        showView(self.addOwnerErrorMessageLabel)
                        
                    break;
                    case -3:
                        
                        self.addOwnerErrorMessageLabel.text = NSLocalizedString("user", comment:"") + self.addOwnerField.text + NSLocalizedString("doesn't exist", comment:"")
                        showView(self.addOwnerErrorMessageLabel)
                        
                    break;
                    case -2:
                        
                        self.addOwnerErrorMessageLabel.text = NSLocalizedString("user", comment:"") + self.addOwnerField.text + NSLocalizedString("is already an owner", comment:"")
                        showView(self.addOwnerErrorMessageLabel)
                        
                    break;
                    case -1:
                        
                        self.addOwnerErrorMessageLabel.text = NSLocalizedString("the group", comment:"") + self.addOwnerField.text + NSLocalizedString("doesn't exist", comment:"")
                        showView(self.addOwnerErrorMessageLabel)
                        
                    break;
                    case 0:
                        
                        self.addOwnerErrorMessageLabel.text = NSLocalizedString("user", comment:"") + self.addOwnerField.text + NSLocalizedString("added as owner", comment:"")
                        self.addOwnerErrorMessageLabel.textColor = UIColor.blueColor()
                        showView(self.addOwnerErrorMessageLabel)
                        
                    break;
                    default:
                        
                        self.addOwnerErrorMessageLabel.text = NSLocalizedString("unable to add owner", comment:"")
                        showView(self.addOwnerErrorMessageLabel)
                        
                    }
                    
                } else {
                    
                    self.addOwnerErrorMessageLabel.text = NSLocalizedString("unknown error", comment:"")
                    showView(self.addOwnerErrorMessageLabel)
                    
                }
            }
        
        } else {
            addOwnerErrorMessageLabel.text = NSLocalizedString("you have to type", comment:"")
            addOwnerErrorMessageLabel.textColor = UIColor.redColor()
            showView(addOwnerErrorMessageLabel)
        }
        
        
    }

    @IBAction func listOfMembersButton(sender: AnyObject) {
        
        var done: ActionStringDoneBlock =
        {(picker: ActionSheetStringPicker!, selectedIndex: Int, selectedValue: AnyObject!) -> Void in
        }
        
        var cancel: ActionStringCancelBlock = {(picker: ActionSheetStringPicker!) -> Void in
        }
        
        var groupPicker = ActionSheetStringPicker(title: NSLocalizedString("Members", comment:""), rows: listOfMembers!, initialSelection: 0,
            doneBlock: done,
            cancelBlock: cancel,
            origin: sender)
        
        groupPicker.showActionSheetPicker()
        
    }
    
    @IBAction func leaveGroupButton(sender: AnyObject) {
        
        removeView(addOwnerErrorMessageLabel)
        removeView(leaveGroupErrorMessageLabel)
        
        if leaveGroupLabel.text == NSLocalizedString("leave group", comment:"") {
            
            PFCloud.callFunctionInBackground("subtractMember", withParameters: ["groupname": groupname!]) {
                (object: AnyObject!, error: NSError!) -> Void in
                if error == nil {
                    var listChannels = self.currentUser!["channels"] as NSMutableArray
                    var listGroups = self.currentUser!["joinedGroups"] as NSMutableArray
                    
                    listChannels.removeObject("Group_" + self.groupname!)
                    listGroups.removeObject(self.groupname!)
                    
                    self.currentUser!["channels"] = listChannels
                    self.currentUser!["joinedGroups"] = listGroups
                    
                    self.currentUser!.saveInBackground()
                    
                    self.leaveGroupLabel.text = NSLocalizedString("rejoin group", comment:"")
                    
                } else {
                    self.leaveGroupErrorMessageLabel.text = NSLocalizedString("unable to leave group", comment:"")
                    // TODO : change the image of the button
                    showView(self.leaveGroupErrorMessageLabel)
                }
            }
            
        } else if leaveGroupLabel.text == NSLocalizedString("rejoin group", comment:"") {
            
            PFCloud.callFunctionInBackground("addMember", withParameters: ["groupname": groupname!]) {
                (object: AnyObject!, error: NSError!) -> Void in
                if error == nil {
                    
                    self.currentUser!.addUniqueObject(self.groupname!, forKey: "joinedGroups")
                    self.currentUser!.addUniqueObject("Group_" + self.groupname!, forKey: "channels")
                    
                    self.currentUser!.saveInBackground()
                    
                    self.leaveGroupLabel.text = NSLocalizedString("leave group", comment:"")
                    
                } else {
                    self.leaveGroupErrorMessageLabel.text = NSLocalizedString("unable to rejoin group", comment:"")
                    showView(self.leaveGroupErrorMessageLabel)
                }
            }

            
        }
        
    }
    
    func textFieldShouldReturn(textField: UITextField) {
        textField.resignFirstResponder()
    }
}
