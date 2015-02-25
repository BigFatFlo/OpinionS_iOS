//
//  JoinedGroupsTableViewController.swift
//  OpinionS
//
//  Created by Florent Remis on 06/02/2015.
//  Copyright (c) 2015 Spersio. All rights reserved.
//

import UIKit

class SavedQuestionsTableViewController: UITableViewController {
    
    var currentUser: PFUser?
    var listOfSavedQuestions: [[String: AnyObject]]?
    var listOfQuestionsToDelete: [String] = []
    var page = 0
    
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
            page = 1
            
            PFCloud.callFunctionInBackground("savedQuestions", withParameters: ["firstPage": page]) {
                (result: AnyObject!, error: NSError!) -> Void in
                if error == nil {
                    self.listOfSavedQuestions = result as? [[String: AnyObject]]
                    self.tableView.reloadData()
                }
            }
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        if listOfSavedQuestions != nil {
            return 3
        } else {
            return 0
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if listOfSavedQuestions == nil {
            switch section {
            case 0:
                if page > 1 {
                    return 1
                } else {
                    return 0
                }
            default:
                return 0
            }
        } else {
            switch section {
            case 0:
                if page > 1 {
                    return 1
                } else {
                    return 0
                }
            case 2:
                return 1
            default:
                return self.listOfSavedQuestions!.count
            }
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var section = indexPath.section
        var index = indexPath.row
        
        switch section {
        case 0:
            let cell = tableView.dequeueReusableCellWithIdentifier("newerQuestionsCell", forIndexPath: indexPath) as UITableViewCell
            return cell
        case 2:
            let cell = tableView.dequeueReusableCellWithIdentifier("olderQuestionsCell", forIndexPath: indexPath) as UITableViewCell
            return cell
        default:
            
            let cell = tableView.dequeueReusableCellWithIdentifier("savedQuestionCell", forIndexPath: indexPath) as UITableViewCell
            
            var question = listOfSavedQuestions![index] as [String: AnyObject]
            
            cell.textLabel!.text = NSLocalizedString("asked by", comment:"") + (question["askerUsername"] as String)
            cell.detailTextLabel!.text = question["questionText"] as? String
            
            cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
            
            return cell
        }
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            listOfQuestionsToDelete.append(listOfSavedQuestions![indexPath.row]["questionID"] as String)
            listOfSavedQuestions!.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        
        switch indexPath.section {
        case 0, 2:
            return false
        default:
            return true
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        if !listOfQuestionsToDelete.isEmpty {
            PFCloud.callFunctionInBackground("deleteSavedQuestions", withParameters: ["questions": listOfQuestionsToDelete])
            listOfQuestionsToDelete.removeAll()
        }
        
    }

    
    @IBAction func loadNewerQuestions(sender: AnyObject) {
        page--
        
        if !listOfQuestionsToDelete.isEmpty {
            PFCloud.callFunctionInBackground("deleteSavedQuestions", withParameters: ["questions": listOfQuestionsToDelete])
            listOfQuestionsToDelete.removeAll()
        }
        
        PFCloud.callFunctionInBackground("savedQuestions", withParameters: ["firstPage": page]) {
            (result: AnyObject!, error: NSError!) -> Void in
            if error == nil {
                self.listOfSavedQuestions = result as? [[String: AnyObject]]
                self.tableView.reloadData()
            } else {
                self.page++
            }
        }
    }
    
    @IBAction func loadOlderQuestions(sender: AnyObject) {
        page++
        
        if !listOfQuestionsToDelete.isEmpty {
            PFCloud.callFunctionInBackground("deleteSavedQuestions", withParameters: ["questions": listOfQuestionsToDelete])
            listOfQuestionsToDelete.removeAll()
        }
        
        PFCloud.callFunctionInBackground("savedQuestions", withParameters: ["firstPage": page]) {
            (result: AnyObject!, error: NSError!) -> Void in
            if error == nil {
                if !(result as [[String: AnyObject]]).isEmpty {
                    self.listOfSavedQuestions = result as? [[String: AnyObject]]
                    self.tableView.reloadData()
                } else {
                    self.page--
                }
            } else {
                self.page--
            }
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var resultsViewController = segue.destinationViewController as ResultsViewController
        if segue.identifier == "showResultsForSavedQuestionSegue" {
            if let index = self.tableView.indexPathForCell(sender as UITableViewCell)?.row {
                var question = listOfSavedQuestions![index] as [String: AnyObject]
                var questionID = question["questionID"] as String
                var questionText = question["questionText"] as String
                var askerUsername = question["askerUsername"] as String
                var groupName = question["groupname"] as String
                var createdAt = question["createdAt"] as NSDate
                var nbrAnswers = question["nbrAnswers"] as Int
                var numberOfResponses = question["nA"] as Int
                var answers = [question["answer1"] as String, question["answer2"] as String, question["answer3"] as String, question["answer4"] as String, question["answer5"] as String]
                var numberForAnswer = [question["nA1"] as Int,question["nA2"] as Int,question["nA3"] as Int,question["nA4"] as Int,question["nA5"] as Int]
                var percentageForAnswer = [question["pcA1"] as Double, question["pcA2"] as Double, question["pcA3"] as Double, question["pcA4"] as Double, question["pcA5"] as Double]
                var group = question["group"] as Bool
                var subscribersOnly = question["subscribersOnly"] as Bool
                
                resultsViewController.question = Question(questionID: questionID, text: questionText, askerUsername: askerUsername, groupName: groupName, createdAt: createdAt, nbrAnswers: nbrAnswers, numberOfResponses: numberOfResponses, answers: answers, numberForAnswer: numberForAnswer, percentageForAnswer: percentageForAnswer, group: group, subscribersOnly: subscribersOnly, savedQuestion: true)
            }
        }
    }
    
}