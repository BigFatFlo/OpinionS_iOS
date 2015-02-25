//
//  ProfileViewController.swift
//  OpinionS
//
//  Created by Florent Remis on 19/01/2015.
//  Copyright (c) 2015 Spersio. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var profileTitle: UILabel!
    @IBOutlet weak var selectCountry: UILabel!
    @IBOutlet weak var selectCountryButton: UIButton!
    @IBOutlet weak var selectInternational: UILabel!
    @IBOutlet weak var selectInternationalButton: UISwitch!
    @IBOutlet weak var selectSex: UILabel!
    @IBOutlet weak var selectSexButton: UIButton!
    @IBOutlet weak var selectDate: UILabel!
    @IBOutlet weak var selectDateButton: UIButton!
    @IBOutlet weak var selectSalary: UILabel!
    @IBOutlet weak var selectSalaryButton: UIButton!
    @IBOutlet weak var errorMessageLabel: UILabel!
    @IBOutlet weak var saveButton: UIButton!
    
    var currentUser: PFUser?
    var listCountries: [String]?
    var listDates: [Int]?
    var listSalaries: [String]?
    var actualCharNumber = -1
    var actualCountry = ""
    var international = false
    var selectedSalaryRange = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        removeView(errorMessageLabel)
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        removeView(errorMessageLabel)
        
        currentUser = PFUser.currentUser()
        
        if currentUser == nil {
            self.tabBarController?.selectedIndex = 0
        } else {
            PFConfig.getConfigInBackgroundWithBlock {
                (var config: PFConfig!, error: NSError!) -> Void in
                if (error == nil) {
                } else {
                    config = PFConfig.currentConfig()
                }
            
            self.listCountries = config["listOfCountries"] as? [String]
            self.listDates = config["listOfDates"] as? [Int]
            self.listSalaries = config["listOfSalaries"] as? [String]
            
            }
            
            actualCharNumber = currentUser!["characteristicsNumber"] as Int
            actualCountry = currentUser!["country"] as String
            international = currentUser!["international"] as Bool
            
            if actualCharNumber != -1 {
                
                var sexString = ""
                var dateOfBirth = 0
                var internationalChoice = ""
                
                if actualCharNumber < 1000 {
                    sexString = NSLocalizedString("man", comment:"")
                } else {
                    sexString = NSLocalizedString("woman", comment:"")
                }
                
                var salaryRange = actualCharNumber % 10
                
                let absoluteDateOfBirth = ((actualCharNumber%1000) - (actualCharNumber%10))/10;
                if absoluteDateOfBirth < 15 {
                    dateOfBirth = absoluteDateOfBirth + 2000;
                } else {
                    dateOfBirth = absoluteDateOfBirth + 1900;
                }
                
                if international {
                    internationalChoice = NSLocalizedString("want", comment:"")
                } else {
                    internationalChoice = NSLocalizedString("don't want", comment:"")
                }
                
                removeView(selectSex)
                removeView(selectSexButton)
                removeView(selectDate)
                removeView(selectDateButton)
                removeView(selectInternational)
                removeView(selectInternationalButton)
                selectInternationalButton.hidden = true
                removeView(selectSalary)
                removeView(selectSalaryButton)
                removeView(saveButton)
                
                var string1 = NSLocalizedString("you are", comment:"") + sexString +
                            NSLocalizedString("born in", comment:"") + String(dateOfBirth)
                
                var string2 = NSLocalizedString("living in", comment:"") + actualCountry +
                            NSLocalizedString("have a salary", comment:"") + String(salaryRange*10000)
                
                var string3 = NSLocalizedString("euro and", comment:"") + String((salaryRange+1)*10000) +
                            NSLocalizedString("euro", comment:"")
                
                var string4 = NSLocalizedString("and", comment:"") + internationalChoice +
                            NSLocalizedString("to receive international", comment:"")
                
                profileTitle.text = string1 + string2 + string3 + string4
                    
                
                profileTitle.font = UIFont.systemFontOfSize(16)
                
                selectCountry.text = NSLocalizedString("change your profile", comment:"")
                selectCountryButton.setTitle(NSLocalizedString("change", comment:""), forState: UIControlState.Normal)
                
            }
            
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func selectCountryButton(sender: AnyObject) {
        removeView(errorMessageLabel)
        
        var currentTitle = selectCountryButton.currentTitle
        
        if currentTitle == NSLocalizedString("change", comment:"") {
            
            profileTitle.font = UIFont.systemFontOfSize(20)
            profileTitle.text = NSLocalizedString("complete your profile", comment:"")
            selectCountry.text = NSLocalizedString("select country", comment:"")
            currentTitle = NSLocalizedString("select", comment:"")
            selectCountryButton.setTitle(currentTitle, forState: UIControlState.Normal)
            showView(selectSex)
            showView(selectSexButton)
            showView(selectDate)
            showView(selectDateButton)
            showView(selectInternational)
            showView(selectInternationalButton)
            selectInternationalButton.hidden = false
            showView(selectSalary)
            showView(selectSalaryButton)
            showView(saveButton)
            
        } else {
        
        var done: ActionStringDoneBlock =
        {(picker: ActionSheetStringPicker!, selectedIndex: Int, selectedValue: AnyObject!) -> Void in
            self.selectCountryButton.setTitle(selectedValue as? String, forState: UIControlState.Normal)
        }
        
        var cancel: ActionStringCancelBlock = {(picker: ActionSheetStringPicker!) -> Void in
            self.selectCountryButton.setTitle(currentTitle, forState: UIControlState.Normal)
            }
        
        
        var groupPicker = ActionSheetStringPicker(title: NSLocalizedString("country", comment:""), rows: listCountries, initialSelection: 0,
            doneBlock: done,
            cancelBlock: cancel,
            origin: sender)
        
        groupPicker.showActionSheetPicker()
            
        }
    
    }
    
    @IBAction func selectSexButton(sender: AnyObject) {
        removeView(errorMessageLabel)
        
        var currentTitle = selectSexButton.currentTitle
        var done: ActionStringDoneBlock =
        {(picker: ActionSheetStringPicker!, selectedIndex: Int, selectedValue: AnyObject!) -> Void in
            self.selectSexButton.setTitle(selectedValue as? String, forState: UIControlState.Normal)
        }
        
        var cancel: ActionStringCancelBlock = {(picker: ActionSheetStringPicker!) -> Void in
            self.selectSexButton.setTitle(currentTitle, forState: UIControlState.Normal)
        }
        
        var groupPicker = ActionSheetStringPicker(title: NSLocalizedString("gender", comment:""), rows: [NSLocalizedString("Man", comment:""),NSLocalizedString("Woman", comment:"")], initialSelection: 0,
            doneBlock: done,
            cancelBlock: cancel,
            origin: sender)
        
        groupPicker.showActionSheetPicker()
    }
    
    @IBAction func selectDateButton(sender: AnyObject) {
        removeView(errorMessageLabel)
        
        var currentTitle = selectDateButton.currentTitle
        var done: ActionStringDoneBlock =
        {(picker: ActionSheetStringPicker!, selectedIndex: Int, selectedValue: AnyObject!) -> Void in
            self.selectDateButton.setTitle(String(selectedValue as Int), forState: UIControlState.Normal)
        }
        
        var cancel: ActionStringCancelBlock = {(picker: ActionSheetStringPicker!) -> Void in
            self.selectDateButton.setTitle(currentTitle, forState: UIControlState.Normal)
        }
        
        
        var groupPicker = ActionSheetStringPicker(title: NSLocalizedString("date of birth", comment:""), rows: listDates, initialSelection: 0,
            doneBlock: done,
            cancelBlock: cancel,
            origin: sender)
        
        groupPicker.showActionSheetPicker()
    }
    
    @IBAction func selectSalaryButton(sender: AnyObject) {
        removeView(errorMessageLabel)
        
        var currentTitle = selectSalaryButton.currentTitle
        var done: ActionStringDoneBlock =
        {(picker: ActionSheetStringPicker!, selectedIndex: Int, selectedValue: AnyObject!) -> Void in
            self.selectSalaryButton.setTitle(selectedValue as? String, forState: UIControlState.Normal)
            self.selectedSalaryRange = selectedIndex
        }
        
        var cancel: ActionStringCancelBlock = {(picker: ActionSheetStringPicker!) -> Void in
            self.selectSalaryButton.setTitle(currentTitle, forState: UIControlState.Normal)
            self.selectedSalaryRange = -1
        }
        
        
        var groupPicker = ActionSheetStringPicker(title: NSLocalizedString("salary", comment:"") + "(" + NSLocalizedString("currencySymbol", comment:"") + ")", rows: listSalaries, initialSelection: 0,
            doneBlock: done,
            cancelBlock: cancel,
            origin: sender)
        
        groupPicker.showActionSheetPicker()
    }
    
    @IBAction func saveButton(sender: AnyObject) {
        removeView(errorMessageLabel)
        
        var selectedCountry = selectCountryButton.currentTitle
        var selectedSex = selectSexButton.currentTitle
        var selectedSexNumber = -1
        if selectedSex == NSLocalizedString("Man", comment:"") {
            selectedSexNumber = 0
        } else if selectedSex == NSLocalizedString("Woman", comment:"") {
            selectedSexNumber = 1
        }
        var selectedDate = selectDateButton.currentTitle?.toInt()
        
        if selectedCountry != NSLocalizedString("select", comment:"") && selectedSexNumber != -1 && selectedSalaryRange != -1 && selectedDate != nil {
            
            var internationalChoice = "";
            if selectInternationalButton.on {
                internationalChoice = NSLocalizedString("want", comment:"")
            } else {
                internationalChoice = NSLocalizedString("don't want", comment:"")
            }
            
            var newCharNumber = 1000*selectedSexNumber + 10*((selectedDate!-1900)%100) + selectedSalaryRange
            
            var changeOfCountry = selectedCountry != actualCountry
            var changeOfCharNumber = ((newCharNumber != actualCharNumber) && (actualCharNumber != -1))
            var newProfile = ((newCharNumber != actualCharNumber) && (actualCharNumber == -1));
            var changeOfInternational = (international != selectInternationalButton.on);
            
            if changeOfCountry || changeOfCharNumber || newProfile || changeOfInternational {
                
                var string1 = NSLocalizedString("do you confirm", comment:"") + selectedSex! +
                    NSLocalizedString("born in", comment:"") + String(selectedDate!)
                
                var string2 = NSLocalizedString("living in", comment:"") + selectedCountry! +
                    NSLocalizedString("have a salary", comment:"") + String(selectedSalaryRange*10000)
                
                var string3 = NSLocalizedString("euro and", comment:"") + String((selectedSalaryRange+1)*10000) +
                    NSLocalizedString("euro", comment:"")
                
                var string4 = NSLocalizedString("and", comment:"") + internationalChoice +
                    NSLocalizedString("to receive international", comment:"") + "?"

                var message = string1 + string2 + string3 + string4
            
                var alertController = UIAlertController(title: NSLocalizedString("confirm profile", comment:""), message: message, preferredStyle: UIAlertControllerStyle.Alert)
                var cancelAction = UIAlertAction(title: NSLocalizedString("no", comment:""), style: UIAlertActionStyle.Cancel) {UIAlertAction -> Void in }
                
                func confirmBlock(UIAlertAction!) -> Void {PFCloud.callFunctionInBackground("changeOfProfile", withParameters: ["oldCharNumber": self.actualCharNumber, "newCharNumber": newCharNumber, "oldCountry": self.actualCountry, "newCountry": selectedCountry!, "newProfile": newProfile, "changeOfCountry": changeOfCountry, "changeOfCharNumber": changeOfCharNumber, "changeOfInternational": changeOfInternational, "international": self.selectInternationalButton.on]) {(object: AnyObject!, error: NSError!) -> Void in
                    if error == nil {
                        
                        self.currentUser!["country"] = selectedCountry
                        self.currentUser!["characteristicsNumber"] = newCharNumber
                        self.currentUser!["international"] = self.selectInternationalButton.on
                        
                        self.currentUser!.saveInBackground()
                        
                        self.tabBarController?.selectedIndex = 0
                        
                    } else {
                        
                        showView(self.errorMessageLabel)
                        self.errorMessageLabel.text = NSLocalizedString("couldn't save profile", comment:"")
                        
                    }
                    
                    }
                    
                }
                var confirmAction = UIAlertAction(title: NSLocalizedString("yes", comment:""), style: UIAlertActionStyle.Default, handler: confirmBlock)
                
                alertController.addAction(cancelAction)
                alertController.addAction(confirmAction)
                presentViewController(alertController, animated: true) {() -> Void in}
                
                
            } else {
                showView(errorMessageLabel)
                errorMessageLabel.text = NSLocalizedString("no changes", comment:"")
            }
            
        } else {
            showView(errorMessageLabel)
            errorMessageLabel.text = NSLocalizedString("profile not complete", comment:"")
        }
        
    }
    

}
