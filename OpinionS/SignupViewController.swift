//
//  SignupViewController.swift
//  OpinionS
//
//  Created by Florent Remis on 19/01/2015.
//  Copyright (c) 2015 Spersio. All rights reserved.
//

import UIKit

class SignupViewController: UIViewController {
    
    var delegate: loginViewStarter? = nil

    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var passwordAgainField: UITextField!
    @IBOutlet weak var errorMessageLabel: UILabel!
    @IBOutlet weak var activityIndicatorPlacement: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        removeView(errorMessageLabel)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func signUpButton(sender: AnyObject) {
        
        showView(errorMessageLabel)
        
        if usernameField.text.isEmpty {
            errorMessageLabel.text = NSLocalizedString("no username for sign up", comment: "")
        } else if emailField.text.isEmpty {
            errorMessageLabel.text = NSLocalizedString("no email for sign up", comment: "")
        } else if passwordField.text.isEmpty {
            errorMessageLabel.text = NSLocalizedString("no password for sign up", comment: "")
        } else if passwordAgainField.text.isEmpty {
            errorMessageLabel.text = NSLocalizedString("no password again for sign up", comment: "")
        } else if passwordAgainField.text != passwordField.text {
            errorMessageLabel.text = NSLocalizedString("not same password", comment: "")
        } else if usernameField.text.utf16Count > 40 || emailField.text.utf16Count > 40 || passwordField.text.utf16Count > 40 || passwordAgainField.text.utf16Count > 40 {
            errorMessageLabel.text = NSLocalizedString("one field is too long", comment: "")
        } else {
            
            errorMessageLabel.hidden = true
            
            var activityIndicator = showActivityIndicator(self.view, activityIndicatorPlacement)
        
            var user = PFUser()
            user.username = usernameField.text
            user.password = passwordField.text
            user.email = emailField.text
            user["country"] = ""
            user["international"] = false
            user["characteristicsNumber"] = -1
            user["nbrQuestionsAsked"] = 0
            user["nbrSubscribers"] = 0
            
            user.signUpInBackgroundWithBlock {
                (succeeded: Bool!, error: NSError!) -> Void in
                if error == nil {
                    dismissActivityIndicator(activityIndicator)
                    self.delegate?.backFromLogin()
                    self.presentingViewController!.presentingViewController!.dismissViewControllerAnimated(true, nil)
                } else {
                    dismissActivityIndicator(activityIndicator)
                    self.errorMessageLabel.text = NSLocalizedString("sign up failed", comment: "")
                    self.errorMessageLabel.hidden = false
                }
            }
        }
        
    }
    
    @IBAction func backToLoginButtonFromSignup(sender: AnyObject) {
        self.presentingViewController!.dismissViewControllerAnimated(true, nil)
    }
    

}
