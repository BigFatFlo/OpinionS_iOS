//
//  AskViewController.swift
//  OpinionS
//
//  Created by Florent Remis on 26/01/2015.
//  Copyright (c) 2015 Spersio. All rights reserved.
//

import UIKit

class AskViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var questionField: UITextField!
    @IBOutlet weak var questionErrorMessageLabel: UILabel!
    @IBOutlet weak var answerField: UITextField!
    @IBOutlet weak var answerErrorMessageLabel: UILabel!
    @IBOutlet weak var questionPreview: UILabel!
    @IBOutlet weak var number1: UIImageView!
    @IBOutlet weak var number2: UIImageView!
    @IBOutlet weak var number3: UIImageView!
    @IBOutlet weak var number4: UIImageView!
    @IBOutlet weak var number5: UIImageView!
    @IBOutlet weak var answer1: UILabel!
    @IBOutlet weak var answer2: UILabel!
    @IBOutlet weak var answer3: UILabel!
    @IBOutlet weak var answer4: UILabel!
    @IBOutlet weak var answer5: UILabel!
    @IBOutlet weak var delete1: UIButton!
    @IBOutlet weak var delete2: UIButton!
    @IBOutlet weak var delete3: UIButton!
    @IBOutlet weak var delete4: UIButton!
    @IBOutlet weak var delete5: UIButton!
    @IBOutlet weak var usersAvailable: UILabel!
    @IBOutlet weak var usersAvailableErrorMessageLabel: UILabel!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var askSubscribersButton: UIButton!
    @IBOutlet weak var askGroupButton: UIButton!
    
    var nbrAnswers = 0
    var ask_type = -1
    var nbrSubscribers = 0
    var nbrUsersTargeted = 0
    var nbrUsersAvailable = 0
    var groupName = ""
    var answers: [UILabel!] = []
    var numbers: [UIImageView!] = []
    var delete: [UIButton!] = []
    
    var constraintsArray: [String: [NSLayoutConstraint]] = ["numbers1":[]]
    
    var currentUser: PFUser?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        askSubscribersButton.setImage(UIImage(named: "radio_off"), forState: UIControlState.Normal)
        askGroupButton.setImage(UIImage(named: "radio_off"), forState: UIControlState.Normal)
        
        removeView(questionErrorMessageLabel)
        removeView(answerErrorMessageLabel)
        removeView(usersAvailableErrorMessageLabel)
        removeView(usersAvailable)
        removeView(sendButton)
        
        numbers = [number1, number2, number3, number4, number5]
        answers = [answer1, answer2, answer3, answer4, answer5]
        delete = [delete1, delete2, delete3, delete4, delete5]
        
        for i in 0...4 {
            constraintsArray["numbers\(i+1)"] = removeViewWithReset(numbers[i])
            constraintsArray["answers\(i+1)"] = removeViewWithReset(answers[i])
            constraintsArray["delete\(i+1)"] = removeViewWithReset(delete[i])
            
        }
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        currentUser = PFUser.currentUser()
        
        if currentUser == nil {
            self.tabBarController?.selectedIndex = 0
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func addQuestionButton(sender: AnyObject) {
        questionField.resignFirstResponder()
        if questionField.text.utf16Count > 8 {
            removeView(questionErrorMessageLabel)
            questionPreview.text = questionField.text
        } else {
            showView(questionErrorMessageLabel)
            questionErrorMessageLabel.text = NSLocalizedString("question not long enough", comment: "")
            questionErrorMessageLabel.textColor = UIColor.redColor()
        }
    }
    
    @IBAction func addAnswer(sender: AnyObject) {
        answerField.resignFirstResponder()
        if answerField.text.utf16Count > 0 {
            if nbrAnswers < 5 {
                removeView(answerErrorMessageLabel)
                showViewWithReset(numbers[nbrAnswers], constraintsArray["numbers\(nbrAnswers+1)"]!)
                showViewWithReset(answers[nbrAnswers], constraintsArray["answers\(nbrAnswers+1)"]!)
                showViewWithReset(delete[nbrAnswers], constraintsArray["delete\(nbrAnswers+1)"]!)
                answers[nbrAnswers].text = answerField.text
                nbrAnswers++
            } else {
                showView(answerErrorMessageLabel)
                answerErrorMessageLabel.text = NSLocalizedString("answers max", comment: "")
                answerErrorMessageLabel.textColor = UIColor.redColor()
            }
        }
    }
    
    @IBAction func deleteAnswer(sender: UIButton) {
        if let answerNumber = sender.currentTitle?.toInt() {
            if answers[answerNumber - 1].text?.utf16Count > 0 {
                if nbrAnswers > 0 && nbrAnswers < 6 {
                    removeView(answerErrorMessageLabel)
                    for (var i = answerNumber-1; i < nbrAnswers - 1; i++) {
                        answers[i].text = answers[i+1].text
                    }
                    answers[nbrAnswers - 1].text = ""
                    constraintsArray["numbers\(nbrAnswers)"] = removeViewWithReset(numbers[nbrAnswers - 1])
                    constraintsArray["answers\(nbrAnswers)"] = removeViewWithReset(answers[nbrAnswers - 1])
                    constraintsArray["delete\(nbrAnswers)"] = removeViewWithReset(delete[nbrAnswers - 1])
                    nbrAnswers--
                }
            }
        }
        
    }
    
    @IBAction func askSubscribersButton(sender: AnyObject) {
        showView(usersAvailable)
        showView(sendButton)
        if (questionPreview.text!.utf16Count > 8 && nbrAnswers > 1 && nbrAnswers < 6 && questionPreview.text != NSLocalizedString("here you can see", comment:"")) {
            ask_type = 0
            askSubscribersButton.setImage(UIImage(named: "radio_on"), forState: UIControlState.Normal)
            askGroupButton.setImage(UIImage(named: "radio_off"), forState: UIControlState.Normal)
            currentUser?.fetchInBackgroundWithBlock() {
                (user: PFObject!, error: NSError!) -> Void in
                if error == nil {
                    self.sendToSubscribers(user as PFUser)
                } else {
                    self.sendToSubscribers(self.currentUser! as PFUser)
                }
            }
        } else {
            showView(usersAvailableErrorMessageLabel)
            removeView(usersAvailable)
            removeView(sendButton)
            usersAvailableErrorMessageLabel.text = NSLocalizedString("need to add", comment:"")
            askSubscribersButton.setImage(UIImage(named: "radio_off"), forState: UIControlState.Normal)
            askGroupButton.setImage(UIImage(named: "radio_off"), forState: UIControlState.Normal)
            ask_type = -1
            nbrUsersTargeted = 0
            groupName = ""
            self.scrollView.scrollRectToVisible(usersAvailableErrorMessageLabel.frame, animated: true)
        }
    }
    
    func sendToSubscribers(user: PFUser) {
        nbrSubscribers = user["nbrSubscribers"] as Int
        if nbrSubscribers <= 0 {
            showView(usersAvailableErrorMessageLabel)
            removeView(usersAvailable)
            removeView(sendButton)
            usersAvailableErrorMessageLabel.text = NSLocalizedString("no subscribers", comment:"")
            askSubscribersButton.setImage(UIImage(named: "radio_off"), forState: UIControlState.Normal)
            askGroupButton.setImage(UIImage(named: "radio_off"), forState: UIControlState.Normal)
            ask_type = -1
            nbrUsersTargeted = 0
            groupName = ""
            removeView(usersAvailable)
            removeView(sendButton)
        } else {
            removeView(usersAvailableErrorMessageLabel)
            nbrUsersTargeted = nbrSubscribers
            groupName = ""
            usersAvailable.text = NSLocalizedString("send to", comment:"") + String(nbrSubscribers) + NSLocalizedString("subscribers", comment:"")
            self.scrollView.scrollRectToVisible(self.sendButton.frame, animated: true)
        }
    }
    
    @IBAction func askGroupButton(sender: AnyObject) {
        removeView(usersAvailable)
        removeView(sendButton)
        if (questionPreview.text!.utf16Count > 8 && nbrAnswers > 1 && nbrAnswers < 6 && questionPreview.text! != NSLocalizedString("here you can see", comment:"")) {
            ask_type = 1
            askSubscribersButton.setImage(UIImage(named: "radio_off"), forState: UIControlState.Normal)
            askGroupButton.setImage(UIImage(named: "radio_on"), forState: UIControlState.Normal)
            currentUser?.fetchInBackgroundWithBlock() {
                (user: PFObject!, error: NSError!) -> Void in
                if error == nil {
                    self.sendToGroup(user as PFUser, sender: sender)
                } else {
                    self.sendToGroup(self.currentUser! as PFUser, sender: sender)
                }
            }
        } else {
            showView(usersAvailableErrorMessageLabel)
            usersAvailableErrorMessageLabel.text = NSLocalizedString("need to add", comment:"")
            askSubscribersButton.setImage(UIImage(named: "radio_off"), forState: UIControlState.Normal)
            askGroupButton.setImage(UIImage(named: "radio_off"), forState: UIControlState.Normal)
            ask_type = -1
            nbrUsersTargeted = 0
            groupName = ""
            self.scrollView.scrollRectToVisible(usersAvailableErrorMessageLabel.frame, animated: true)
        }

    }
    
    func sendToGroup(user: PFUser, sender: AnyObject) {
        if let listGroups = user["ownedGroups"] as [String]? {
            if listGroups.isEmpty {
                showView(usersAvailableErrorMessageLabel)
                usersAvailableErrorMessageLabel.text = NSLocalizedString("no groups", comment:"")
                askSubscribersButton.setImage(UIImage(named: "radio_off"), forState: UIControlState.Normal)
                askGroupButton.setImage(UIImage(named: "radio_off"), forState: UIControlState.Normal)
                ask_type = -1
                nbrUsersTargeted = 0
                groupName = ""
            } else {
                showView(self.usersAvailable)
                showView(self.sendButton)
                removeView(usersAvailableErrorMessageLabel)
                
                var done: ActionStringDoneBlock =
                    {(picker: ActionSheetStringPicker!, selectedIndex: Int, selectedValue: AnyObject!) -> Void in
                        self.groupName = selectedValue as String
                        PFCloud.callFunctionInBackground("nbrMembersInGroup", withParameters:["username": self.currentUser!.username, "groupname": self.groupName]) {
                            (result: AnyObject!, error: NSError!) -> Void in
                            if error == nil {
                                switch result as Int {
                                case -2:
                                    showView(self.usersAvailableErrorMessageLabel)
                                    removeView(self.usersAvailable)
                                    removeView(self.sendButton)
                                    self.usersAvailableErrorMessageLabel.text = NSLocalizedString("not owner", comment:"")
                                    self.askSubscribersButton.setImage(UIImage(named: "radio_off"), forState: UIControlState.Normal)
                                    self.askGroupButton.setImage(UIImage(named: "radio_off"), forState: UIControlState.Normal)
                                    self.nbrUsersTargeted = 0
                                    self.groupName = ""
                                case -1:
                                    showView(self.usersAvailableErrorMessageLabel)
                                    removeView(self.usersAvailable)
                                    removeView(self.sendButton)
                                    self.usersAvailableErrorMessageLabel.text = NSLocalizedString("group doesn't exist", comment:"")
                                    self.askSubscribersButton.setImage(UIImage(named: "radio_off"), forState: UIControlState.Normal)
                                    self.askGroupButton.setImage(UIImage(named: "radio_off"), forState: UIControlState.Normal)
                                    self.nbrUsersTargeted = 0
                                    self.groupName = ""
                                case 0:
                                    showView(self.usersAvailableErrorMessageLabel)
                                    removeView(self.usersAvailable)
                                    removeView(self.sendButton)
                                    self.usersAvailableErrorMessageLabel.text = NSLocalizedString("group is empty", comment:"")
                                    self.askSubscribersButton.setImage(UIImage(named: "radio_off"), forState: UIControlState.Normal)
                                    self.askGroupButton.setImage(UIImage(named: "radio_off"), forState: UIControlState.Normal)
                                    self.nbrUsersTargeted = 0
                                    self.groupName = ""
                                default:
                                    removeView(self.usersAvailableErrorMessageLabel)
                                    self.nbrUsersTargeted = result as Int
                                    self.usersAvailable.text = NSLocalizedString("send to the", comment:"") + String(self.nbrUsersTargeted) + NSLocalizedString("members of", comment:"") + self.groupName
                                    self.scrollView.scrollRectToVisible(self.sendButton.frame, animated: true)
                                }
                            } else {
                                showView(self.usersAvailableErrorMessageLabel)
                                removeView(self.usersAvailable)
                                removeView(self.sendButton)
                                self.usersAvailableErrorMessageLabel.text = NSLocalizedString("no info on group", comment:"")
                                self.askSubscribersButton.setImage(UIImage(named: "radio_off"), forState: UIControlState.Normal)
                                self.askGroupButton.setImage(UIImage(named: "radio_off"), forState: UIControlState.Normal)
                                self.nbrUsersTargeted = 0
                                self.groupName = ""
                            }
                        }
                    }
                
                var cancel: ActionStringCancelBlock = {(picker: ActionSheetStringPicker!) -> Void in
                    self.groupName = ""
                    self.askSubscribersButton.setImage(UIImage(named: "radio_off"), forState: UIControlState.Normal)
                    self.askGroupButton.setImage(UIImage(named: "radio_off"), forState: UIControlState.Normal)
                    removeView(self.usersAvailable)
                    removeView(self.sendButton)}

                
                var groupPicker = ActionSheetStringPicker(title: "Select a group", rows: listGroups, initialSelection: 0,
                    doneBlock: done,
                    cancelBlock: cancel,
                    origin: sender)
                
                groupPicker.showActionSheetPicker()
            }
            
        } else {
            showView(usersAvailableErrorMessageLabel)
            usersAvailableErrorMessageLabel.text = NSLocalizedString("no groups", comment:"")
            askSubscribersButton.setImage(UIImage(named: "radio_off"), forState: UIControlState.Normal)
            askGroupButton.setImage(UIImage(named: "radio_off"), forState: UIControlState.Normal)
            ask_type = -1
            nbrUsersTargeted = 0
            groupName = ""
        }
    }
    
    @IBAction func sendButton(sender: AnyObject) {
        if ask_type == -1 {
            showView(usersAvailableErrorMessageLabel)
            usersAvailableErrorMessageLabel.text = NSLocalizedString("no users criteria", comment:"")
            askSubscribersButton.setImage(UIImage(named: "radio_off"), forState: UIControlState.Normal)
            askGroupButton.setImage(UIImage(named: "radio_off"), forState: UIControlState.Normal)
            ask_type = -1
            nbrUsersTargeted = 0
            groupName = ""
            removeView(usersAvailable)
            removeView(sendButton)
        } else if nbrUsersTargeted == 0 {
            showView(usersAvailableErrorMessageLabel)
            usersAvailableErrorMessageLabel.text = NSLocalizedString("no targeted users", comment:"")
            askSubscribersButton.setImage(UIImage(named: "radio_off"), forState: UIControlState.Normal)
            askGroupButton.setImage(UIImage(named: "radio_off"), forState: UIControlState.Normal)
            ask_type = -1
            nbrUsersTargeted = 0
            groupName = ""
            removeView(usersAvailable)
            removeView(sendButton)
        } else if (questionPreview.text!.utf16Count > 8 && nbrAnswers > 1 && nbrAnswers < 6 && questionPreview.text! != NSLocalizedString("here you can see", comment:"")) {
            var group: Bool = false
            var subscribersOnly: Bool = false
            switch ask_type {
            case 0:
                group = false
                subscribersOnly = true
            case 1:
                if groupName == "" {
                    showView(usersAvailableErrorMessageLabel)
                    usersAvailableErrorMessageLabel.text = NSLocalizedString("no group", comment:"")
                    askSubscribersButton.setImage(UIImage(named: "radio_off"), forState: UIControlState.Normal)
                    askGroupButton.setImage(UIImage(named: "radio_off"), forState: UIControlState.Normal)
                    ask_type = -1
                    nbrUsersTargeted = 0
                    groupName = ""
                    removeView(usersAvailable)
                    removeView(sendButton)
                } else {
                    group = true
                    subscribersOnly = false
                }
            default:
                showView(usersAvailableErrorMessageLabel)
                usersAvailableErrorMessageLabel.text = NSLocalizedString("unknown error", comment:"")
                askSubscribersButton.setImage(UIImage(named: "radio_off"), forState: UIControlState.Normal)
                askGroupButton.setImage(UIImage(named: "radio_off"), forState: UIControlState.Normal)
                ask_type = -1
                nbrUsersTargeted = 0
                groupName = ""
                removeView(usersAvailable)
                removeView(sendButton)
            }
            
            PFCloud.callFunctionInBackground("newQuestion", withParameters: ["text": questionPreview.text!, "nbrAnswers": nbrAnswers, "nbrUsersTargeted": nbrUsersTargeted, "group": group, "subscribersOnly": subscribersOnly, "groupname": groupName, "answer1": answer1.text!, "answer2": answer2.text!, "answer3": answer3.text!, "answer4": answer4.text!, "answer5": answer5.text!]) {
                (result: AnyObject!, error: NSError!) -> Void in
                if error == nil {
                    self.tabBarController?.selectedIndex = 0
                } else {
                    showView(self.usersAvailableErrorMessageLabel)
                    self.usersAvailableErrorMessageLabel.text = NSLocalizedString("unable to send", comment:"")
                    self.askSubscribersButton.setImage(UIImage(named: "radio_off"), forState: UIControlState.Normal)
                    self.askGroupButton.setImage(UIImage(named: "radio_off"), forState: UIControlState.Normal)
                    self.ask_type = -1
                    self.nbrUsersTargeted = 0
                    self.groupName = ""
                    removeView(self.usersAvailable)
                    removeView(self.sendButton)
                }
            }
            
            
        } else {
            showView(usersAvailableErrorMessageLabel)
            usersAvailableErrorMessageLabel.text = NSLocalizedString("invalid question", comment:"")
            askSubscribersButton.setImage(UIImage(named: "radio_off"), forState: UIControlState.Normal)
            askGroupButton.setImage(UIImage(named: "radio_off"), forState: UIControlState.Normal)
            ask_type = -1
            nbrUsersTargeted = 0
            groupName = ""
            removeView(usersAvailable)
            removeView(sendButton)
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) {
        textField.resignFirstResponder()
    }
}