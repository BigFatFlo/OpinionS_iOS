//
//  FirstViewController.swift
//  OpinionS
//
//  Created by Florent Remis on 17/01/2015.
//  Copyright (c) 2015 Spersio. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, loginViewStarter {
    
    var fromLogin: Bool = false
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var subscribers: UILabel!
    @IBOutlet weak var errorMessageLabel: UILabel!
    @IBOutlet weak var subscribeErrorMessageLabel: UILabel!
    @IBOutlet weak var subscribeActivityIndicatorLocation: UILabel!
    @IBOutlet weak var joinErrorMessageLabel: UILabel!
    @IBOutlet weak var joinActivityIndicatorLocation: UILabel!
    @IBOutlet weak var profileStatus: UILabel!
    @IBOutlet weak var profileButton: UIButton!
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var groupNameField: UITextField!
    
    var activeField: UITextField?
    
    var currentUser: PFUser?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerForKeyboardNotifications()
        removeView(errorMessageLabel)
        removeView(subscribeErrorMessageLabel)
        removeView(joinErrorMessageLabel)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        currentUser = PFUser.currentUser()
        
        if currentUser != nil {
    
        if currentUser!["characteristicsNumber"] as Int != -1 {
            profileStatus.text = NSLocalizedString("profile is complete", comment: "")
            profileStatus.textColor = UIColor.blueColor()
            removeView(profileButton)
        }
        
        if fromLogin {
            var currentInstallation = PFInstallation.currentInstallation()
            currentInstallation["user"] = currentUser
            let listChannels = currentUser!["channels"] as [String]?
            if (listChannels == nil) {
                currentInstallation["channels"] = []
            } else {
                currentInstallation["channels"] = listChannels!
            }
            
            currentInstallation.saveInBackground()
        }
        
        username.text = currentUser!.username
        
        subscribers.text = NSLocalizedString("you have", comment: "") + String(currentUser!["nbrSubscribers"] as Int) + NSLocalizedString("subscribers", comment: "")
        
        } else {
            performSegueWithIdentifier("notLoggedInSegue", sender: self)
        }
    
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "notLoggedInSegue" {
            let loginViewController = segue.destinationViewController as LoginViewController
            loginViewController.delegate = self
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func backFromLogin() {
        fromLogin = true
    }
    
    @IBAction func refreshButton(sender: AnyObject) {
        currentUser?.fetchInBackgroundWithBlock() {
            (user: PFObject!, error: NSError!) -> Void in
            if error == nil {
                removeView(self.errorMessageLabel)
                self.subscribers.text = NSLocalizedString("you have", comment: "") + String(user["nbrSubscribers"] as Int) + NSLocalizedString("subscribers", comment: "")
            } else {
                showView(self.errorMessageLabel)
                self.errorMessageLabel.text = NSLocalizedString("unable to refresh", comment: "")
            }
        }
        
    }
    
    @IBAction func profileFromHomeButton(sender: AnyObject) {
        self.tabBarController?.selectedIndex = 2
    }
    
    @IBAction func subscribeToUserButton(sender: AnyObject) {
        usernameField.resignFirstResponder()
        removeView(joinErrorMessageLabel)
        
        if !usernameField.text.isEmpty {
        
            showView(subscribeErrorMessageLabel)
            subscribeErrorMessageLabel.hidden = true
            
            let activityIndicator = showActivityIndicator(self.view, subscribeActivityIndicatorLocation)
            
            let askerUsername = usernameField.text
            
            PFCloud.callFunctionInBackground("userExists", withParameters:["username": askerUsername]) {
                (result: AnyObject!, error: NSError!) -> Void in
                if error == nil {
                    if let exists = result as? Bool {
                        if exists {
                            if let subscribedUsers = self.currentUser!["subscribedUsers"] as? [String] {
                                
                                if contains(subscribedUsers, askerUsername) {
                                    dismissActivityIndicator(activityIndicator)
                                    self.subscribeErrorMessageLabel.text = NSLocalizedString("already a subscriber", comment: "")
                                    self.subscribeErrorMessageLabel.textColor = UIColor.redColor()
                                    self.subscribeErrorMessageLabel.hidden = false
                                } else {
                                    self.addSubscriber(self.currentUser!, askerUsername: askerUsername, activityIndicator: activityIndicator)
                                }
                                
                            } else {
                                self.addSubscriber(self.currentUser!, askerUsername: askerUsername, activityIndicator: activityIndicator)
                            }
                            
                        } else {
                            dismissActivityIndicator(activityIndicator)
                            self.subscribeErrorMessageLabel.text = NSLocalizedString("user", comment: "") + askerUsername + NSLocalizedString("doesn't exist", comment: "")
                            self.subscribeErrorMessageLabel.textColor = UIColor.redColor()
                            self.subscribeErrorMessageLabel.hidden = false
                        }
                    } else {
                        dismissActivityIndicator(activityIndicator)
                        self.subscribeErrorMessageLabel.text = NSLocalizedString("unable to subscribe", comment: "")
                        self.subscribeErrorMessageLabel.textColor = UIColor.redColor()
                        self.subscribeErrorMessageLabel.hidden = false
                    }
                }
            }
        
        } else {
            subscribeErrorMessageLabel.hidden = false
            subscribeErrorMessageLabel.text = NSLocalizedString("You have to type", comment: "")
            subscribeErrorMessageLabel.textColor = UIColor.redColor()
            showView(subscribeErrorMessageLabel)
        }
    }
    
    @IBAction func joinGroupButton(sender: AnyObject) {
        groupNameField.resignFirstResponder()
        removeView(subscribeErrorMessageLabel)
        
        if !groupNameField.text.isEmpty {
        
            showView(joinErrorMessageLabel)
            joinErrorMessageLabel.hidden = true
            
            let activityIndicator = showActivityIndicator(self.view, joinActivityIndicatorLocation)
            
            let groupName = groupNameField.text
            let username = currentUser!.username
            
            PFCloud.callFunctionInBackground("groupExists", withParameters:["username": username, "groupname": groupName]) {
                (result: AnyObject!, error: NSError!) -> Void in
                if error == nil {
                    if let exists = result as? Bool {
                        if exists {
                            if let joinedGroups = self.currentUser!["joinedGroups"] as? [String] {
                                
                                if contains(joinedGroups, groupName) {
                                    dismissActivityIndicator(activityIndicator)
                                    self.joinErrorMessageLabel.text = NSLocalizedString("already a member", comment: "")
                                    self.joinErrorMessageLabel.textColor = UIColor.redColor()
                                    self.joinErrorMessageLabel.hidden = false
                                } else {
                                    self.addMember(self.currentUser!, username: username, groupName: groupName, activityIndicator: activityIndicator)
                                }
                                
                            } else {
                                self.addMember(self.currentUser!, username: username, groupName: groupName, activityIndicator: activityIndicator)
                            }
                            
                        } else {
                            dismissActivityIndicator(activityIndicator)
                            self.joinErrorMessageLabel.text = NSLocalizedString("the group", comment: "") + groupName + NSLocalizedString("doesn't exist", comment: "")
                            self.joinErrorMessageLabel.textColor = UIColor.redColor()
                            self.joinErrorMessageLabel.hidden = false
                        }
                    } else {
                        dismissActivityIndicator(activityIndicator)
                        self.joinErrorMessageLabel.text = NSLocalizedString("unable to join", comment: "")
                        self.joinErrorMessageLabel.textColor = UIColor.redColor()
                        self.joinErrorMessageLabel.hidden = false
                    }
                }
            }

        } else {
            subscribeErrorMessageLabel.hidden = false
            subscribeErrorMessageLabel.text = NSLocalizedString("You have to type", comment: "")
            subscribeErrorMessageLabel.textColor = UIColor.redColor()
            showView(subscribeErrorMessageLabel)
        }
    }

    @IBAction func createGroupButton(sender: AnyObject) {
        groupNameField.resignFirstResponder()
        removeView(subscribeErrorMessageLabel)
        
        if !groupNameField.text.isEmpty {
        
            showView(joinErrorMessageLabel)
            joinErrorMessageLabel.hidden = true
            
            let activityIndicator = showActivityIndicator(self.view, joinActivityIndicatorLocation)
            
            let groupName = groupNameField.text
            let username = currentUser!.username
            
            PFCloud.callFunctionInBackground("createGroup", withParameters:["username": username, "groupname": groupName]) {
                (result: AnyObject!, error: NSError!) -> Void in
                if error == nil {
                    if let exists = result as? Bool {
                        if exists {
                            dismissActivityIndicator(activityIndicator)
                            self.joinErrorMessageLabel.text = NSLocalizedString("the group", comment: "") + groupName + NSLocalizedString("already exists", comment: "")
                            self.joinErrorMessageLabel.textColor = UIColor.redColor()
                            self.joinErrorMessageLabel.hidden = false
                            
                        } else {
                            self.currentUser!.addUniqueObject(groupName, forKey: "ownedGroups")
                            self.currentUser!.saveInBackground()
                            
                            dismissActivityIndicator(activityIndicator)
                            self.joinErrorMessageLabel.text = NSLocalizedString("group", comment: "") + groupName + NSLocalizedString("successfully created", comment: "")
                            self.joinErrorMessageLabel.textColor = UIColor.blueColor()
                            self.joinErrorMessageLabel.hidden = false
                            
                        }
                    } else {
                        dismissActivityIndicator(activityIndicator)
                        self.joinErrorMessageLabel.text = NSLocalizedString("unable to create", comment: "")
                        self.joinErrorMessageLabel.textColor = UIColor.redColor()
                        self.joinErrorMessageLabel.hidden = false
                    }
                }
            }
            
        } else {
            subscribeErrorMessageLabel.hidden = false
            subscribeErrorMessageLabel.text = NSLocalizedString("You have to type", comment: "")
            subscribeErrorMessageLabel.textColor = UIColor.redColor()
            showView(subscribeErrorMessageLabel)
        }

    }

    @IBAction func logOutButton(sender: AnyObject) {
        PFUser.logOut()
        performSegueWithIdentifier("notLoggedInSegue", sender: self)
    }
    
    func addMember (user: PFUser, username: String, groupName: String, activityIndicator: UIActivityIndicatorView) {
        
        PFCloud.callFunctionInBackground("addMember", withParameters:["username": username, "groupname": groupName]) {
            (result: AnyObject!, error: NSError!) -> Void in
            if error == nil {
                
                user.addUniqueObject(groupName, forKey: "joinedGroups")
                user.addUniqueObject( "Group_" + groupName, forKey: "channels")
                
                user.saveInBackground();
                
                dismissActivityIndicator(activityIndicator)
                self.joinErrorMessageLabel.text = NSLocalizedString("successfully joined", comment: "") + groupName
                self.joinErrorMessageLabel.textColor = UIColor.blueColor()
                self.joinErrorMessageLabel.hidden = false
                
            } else {
                
                dismissActivityIndicator(activityIndicator)
                self.joinErrorMessageLabel.text = NSLocalizedString("unable to join", comment: "")
                self.joinErrorMessageLabel.textColor = UIColor.redColor()
                self.joinErrorMessageLabel.hidden = false
            }
        }
    }

    
    func addSubscriber (user: PFUser, askerUsername: String, activityIndicator: UIActivityIndicatorView) {
        
        PFCloud.callFunctionInBackground("addSubscriber", withParameters:["username": askerUsername]) {
            (result: AnyObject!, error: NSError!) -> Void in
            if error == nil {
                
                user.addUniqueObject(askerUsername, forKey: "subscribedUsers")
                user.addUniqueObject( "User_" + askerUsername, forKey: "channels")
                
                user.saveInBackground();
                
                dismissActivityIndicator(activityIndicator)
                self.subscribeErrorMessageLabel.text = NSLocalizedString("successfully subscribed", comment: "") + askerUsername + NSLocalizedString("'s questions", comment: "")
                self.subscribeErrorMessageLabel.textColor = UIColor.blueColor()
                self.subscribeErrorMessageLabel.hidden = false
                
            } else {
                
                dismissActivityIndicator(activityIndicator)
                self.subscribeErrorMessageLabel.text = NSLocalizedString("unable to subscribe", comment: "") + askerUsername + NSLocalizedString("'s questions, please", comment: "")
                self.subscribeErrorMessageLabel.textColor = UIColor.redColor()
                self.subscribeErrorMessageLabel.hidden = false
            }
        }
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        activeField = textField
    }
    
    func textFieldShouldReturn(textField: UITextField) {
        textField.resignFirstResponder()
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        activeField = nil
    }
    
    func registerForKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWasShown:", name: UIKeyboardDidShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillBeHidden:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func keyboardWasShown (aNotification: NSNotification) {
        if let info = aNotification.userInfo {
            let kbSize = info[UIKeyboardFrameBeginUserInfoKey]!.CGRectValue().size
                
            var contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0)
            scrollView.contentInset = contentInsets
            scrollView.scrollIndicatorInsets = contentInsets
                
            var aRect = self.view.frame
            aRect.size.height -= kbSize.height
            if activeField != nil {
                if !CGRectContainsPoint(aRect, activeField!.frame.origin) {
                    self.scrollView.scrollRectToVisible(activeField!.frame, animated: true)
                }
            }
        
        }
    }
    
    func keyboardWillBeHidden (aNotification: NSNotification) {
        var contentInsets = UIEdgeInsetsZero
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
    }
    
}



