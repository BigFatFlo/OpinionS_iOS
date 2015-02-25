//
//  UsefulFunctions.swift
//  OpinionS
//
//  Created by Florent Remis on 21/01/2015.
//  Copyright (c) 2015 Spersio. All rights reserved.
//

import Foundation

enum Direction {
    case HORIZONTAL, VERTICAL
}

class Question {
    let questionID: String
    let text: String
    let askerUsername: String
    let groupName: String
    let createdAt: NSDate
    let nbrAnswers: Int
    let numberOfResponses: Int
    let answers: [String]
    let numberForAnswer: [Int]
    let percentageForAnswer: [Double]
    let group: Bool
    let subscribersOnly: Bool
    let savedQuestion: Bool
    
    init(questionID: String,
        text: String,
        askerUsername: String,
        groupName: String,
        createdAt: NSDate,
        nbrAnswers: Int,
        numberOfResponses: Int,
        answers: [String],
        numberForAnswer: [Int],
        percentageForAnswer: [Double],
        group: Bool,
        subscribersOnly: Bool,
        savedQuestion: Bool) {
            
            self.questionID = questionID
            self.text = text
            self.askerUsername = askerUsername
            self.groupName = groupName
            self.createdAt = createdAt
            self.nbrAnswers = nbrAnswers
            self.numberOfResponses = numberOfResponses
            self.answers = answers
            self.numberForAnswer = numberForAnswer
            self.percentageForAnswer = percentageForAnswer
            self.group = group
            self.subscribersOnly = subscribersOnly
            self.savedQuestion = savedQuestion
            
    }
    
}

func removeView(view: UIView, direction: Direction) {
    if direction == .VERTICAL {
        let constraint = NSLayoutConstraint(item: view, attribute: NSLayoutAttribute.Height, relatedBy: .Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 0, constant: 0)
        view.addConstraint(constraint)
    } else {
        let constraint = NSLayoutConstraint(item: view, attribute: NSLayoutAttribute.Width, relatedBy: .Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 0, constant: 0)
        view.addConstraint(constraint)
    }
}

func removeView(view: UIView) {
    let constraintH = NSLayoutConstraint(item: view, attribute: NSLayoutAttribute.Height, relatedBy: .Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 0)
    let constraintW = NSLayoutConstraint(item: view, attribute: NSLayoutAttribute.Width, relatedBy: .Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 0)
    view.addConstraint(constraintH)
    view.addConstraint(constraintW)
}

func removeViewWithReset(view: UIView) -> [NSLayoutConstraint]{
    let constraints = view.constraints() as [NSLayoutConstraint]
    let constraintH = NSLayoutConstraint(item: view, attribute: NSLayoutAttribute.Height, relatedBy: .Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 0)
    let constraintW = NSLayoutConstraint(item: view, attribute: NSLayoutAttribute.Width, relatedBy: .Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 0)
    view.addConstraint(constraintH)
    view.addConstraint(constraintW)
    return constraints
}

func showView(view: UIView) {
    let constraintsArray = view.constraints()
    let size = constraintsArray.count
    for var i = 0; i < size; i++ {
        var constraint = constraintsArray[i] as NSLayoutConstraint
        if isConstraintH(constraint) || isConstraintW(constraint) {
            view.removeConstraint(constraint)
        }
    }
}

func showViewWithReset(view: UIView, constraints: [NSLayoutConstraint]) {
    let constraintsArray = view.constraints()
    let size = constraintsArray.count
    for var i = 0; i < size; i++ {
        var constraint = constraintsArray[i] as NSLayoutConstraint
        if isConstraintH(constraint) || isConstraintW(constraint) {
            view.removeConstraint(constraint)
        }
    }
    view.addConstraints(constraints)
}


func isConstraintH(constraint: NSLayoutConstraint) -> Bool {
    
    if (constraint.firstAttribute != NSLayoutAttribute.Height) {
        return false
    }
    if (constraint.secondAttribute != NSLayoutAttribute.NotAnAttribute) {
        return false
    }
    if (constraint.secondItem != nil) {
        return false
    }
    if (constraint.relation != .Equal) {
        return false
    }
    if (constraint.multiplier != 1) {
        return false
    }
    if (constraint.constant != 0) {
        return false
    }
    
    return true
    
}

func isConstraintW(constraint: NSLayoutConstraint) -> Bool {
    
    if (constraint.firstAttribute != NSLayoutAttribute.Width) {
        return false
    }
    if (constraint.secondAttribute != NSLayoutAttribute.NotAnAttribute) {
        return false
    }
    if (constraint.secondItem != nil) {
        return false
    }
    if (constraint.relation != .Equal) {
        return false
    }
    if (constraint.multiplier != 1) {
        return false
    }
    if (constraint.constant != 0) {
        return false
    }
    
    return true
    
}

func showActivityIndicator (mainView: UIView, viewForCenter: UIView) -> UIActivityIndicatorView {
    var activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
    activityIndicator.frame = viewForCenter.frame
    activityIndicator.center = viewForCenter.center
    mainView.addSubview(activityIndicator)
    activityIndicator.bringSubviewToFront(activityIndicator)
    UIApplication.sharedApplication().networkActivityIndicatorVisible = true
    activityIndicator.startAnimating()
    return activityIndicator
}

func dismissActivityIndicator (activityIndicator: UIActivityIndicatorView) {
    activityIndicator.stopAnimating()
    UIApplication.sharedApplication().networkActivityIndicatorVisible = false
}


