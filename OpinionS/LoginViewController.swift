//
//  LoginViewController.swift
//  OpinionS
//
//  Created by Florent Remis on 19/01/2015.
//  Copyright (c) 2015 Spersio. All rights reserved.
//

import UIKit

protocol loginViewStarter {
    func backFromLogin()
}

class LoginViewController: UIViewController {

    var delegate: loginViewStarter? = nil
    
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
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
    
    @IBAction func logInButton(sender: AnyObject) {
        
        showView(errorMessageLabel)
        
        if usernameField.text.isEmpty {
            errorMessageLabel.text = NSLocalizedString("no username", comment: "")
        } else if passwordField.text.isEmpty {
            errorMessageLabel.text = NSLocalizedString("no password", comment: "")
        } else {
            
            errorMessageLabel.hidden = true
            
            let activityIndicator = showActivityIndicator(self.view, activityIndicatorPlacement)
            
            PFUser.logInWithUsernameInBackground(usernameField.text, password: passwordField.text) {
                (user: PFUser!, error: NSError!) -> Void in
                if user != nil {
                    dismissActivityIndicator(activityIndicator)
                    self.delegate?.backFromLogin()
                    self.presentingViewController!.dismissViewControllerAnimated(true, completion: nil)
                } else {
                    dismissActivityIndicator(activityIndicator)
                    self.errorMessageLabel.hidden = false
                    self.errorMessageLabel.text = NSLocalizedString("login failed", comment: "")
                }
            }
            
        }
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "signUpSegue" {
            let signupViewController = segue.destinationViewController as SignupViewController
            signupViewController.delegate = self.delegate
        }
    }

}
