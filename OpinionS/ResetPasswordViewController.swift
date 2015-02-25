//
//  ResetPasswordViewController.swift
//  OpinionS
//
//  Created by Florent Remis on 22/01/2015.
//  Copyright (c) 2015 Spersio. All rights reserved.
//

import UIKit

class ResetPasswordViewController: UIViewController {
    
    @IBOutlet weak var resetPasswordTitle: UILabel!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var errorMessageLabel: UILabel!
    @IBOutlet weak var resetPasswordButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        removeView(errorMessageLabel,.VERTICAL)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func resetPasswordButton(sender: AnyObject) {
        
        showView(errorMessageLabel)
        
        if emailField.text.isEmpty {
            errorMessageLabel.text = NSLocalizedString("no email for sign up", comment: "")
        } else {
            
            errorMessageLabel.hidden = true
            
            var activityIndicator = showActivityIndicator(self.view, errorMessageLabel)
            
            PFUser.requestPasswordResetForEmailInBackground(emailField.text) {
                (succeeded: Bool!, error: NSError!) -> Void in
                if error == nil {
                    dismissActivityIndicator(activityIndicator)
                    removeView(self.emailField, .VERTICAL)
                    removeView(self.errorMessageLabel, .VERTICAL)
                    removeView(self.resetPasswordButton)
                    self.resetPasswordTitle.text = NSLocalizedString("password reset succeeded", comment: "")
                } else {
                    dismissActivityIndicator(activityIndicator)
                    self.errorMessageLabel.hidden = false
                    self.errorMessageLabel.text = NSLocalizedString("password reset failed", comment: "")
                }
            }

            
        }
    }

    @IBAction func backToLoginButtonFromResetPassword(sender: AnyObject) {
        self.presentingViewController!.dismissViewControllerAnimated(true, nil)
    }
    
}
