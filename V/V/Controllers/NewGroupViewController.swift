//
//  NewGroupViewController.swift
//  V
//
//  Created by Dulio Denis on 6/18/16.
//  Copyright © 2016 Dulio Denis. All rights reserved.
//

import UIKit
import CoreData

class NewGroupViewController: UIViewController {
    
    var context: NSManagedObjectContext?
    // set this when we create our new instance of our VC
    var chatCreationDelegate: ChatCreationDelegate?
    
    private let subjectField = UITextField()
    private let characterNumberLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set the title
        title = "New Group"
        
        // set the background color
        view.backgroundColor = UIColor.whiteColor()
        // set the left and right Navigation Bar Button Items to Cancel & Next
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .Plain, target: self, action: "cancel")
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next", style: .Plain, target: self, action: "next")
        
        // set the placeholder and delegate for our Subject Field variable
        subjectField.placeholder = "Group Subject"
        subjectField.delegate = self
        // falsify the automatic constraints so we can use Auto Layout
        subjectField.translatesAutoresizingMaskIntoConstraints = false
        // add the subjectField to the view
        view.addSubview(subjectField)
        
        // setup the characterNumberLabel view 
        characterNumberLabel.textColor = UIColor.grayColor()
        characterNumberLabel.translatesAutoresizingMaskIntoConstraints = false
        // add the characterNumberLabel as a sub view to our subject field
        subjectField.addSubview(characterNumberLabel)
        
        // add an Auto Layout constrainable light gray bottom border
        let bottomBorder = UIView()
        bottomBorder.backgroundColor = UIColor.lightGrayColor()
        bottomBorder.translatesAutoresizingMaskIntoConstraints = false
        // make bottom border a sub view of the subject field
        subjectField.addSubview(bottomBorder)
        
        // Setup Auto Layout Constraints
        
        let constraints: [NSLayoutConstraint] = [
            // specify that subject field be top constrained to the top layout but not flush - border of 20
            subjectField.topAnchor.constraintEqualToAnchor(topLayoutGuide.bottomAnchor, constant: 20),
            // leading achor should be constrained to the margin's leading anchor
            subjectField.leadingAnchor.constraintEqualToAnchor(view.layoutMarginsGuide.leadingAnchor),
            // and trailing anchor is constrained to the view's trailing anchor
            subjectField.trailingAnchor.constraintEqualToAnchor(view.trailingAnchor),
            // constrain the width of the bottom border to be equal to the subject field's width
            bottomBorder.widthAnchor.constraintEqualToAnchor(subjectField.widthAnchor),
            // the bottom anchor of the bottom border be constrained to the subject field's bottom anchor
            bottomBorder.bottomAnchor.constraintEqualToAnchor(subjectField.bottomAnchor),
            // the leading anchor to the subject field's leading anchor
            bottomBorder.leadingAnchor.constraintEqualToAnchor(subjectField.leadingAnchor),
            // and the bottom border can have a constant height of 1 point
            bottomBorder.heightAnchor.constraintEqualToConstant(1),
            // finally, the character number label center is equal to the subject field's center
            characterNumberLabel.centerYAnchor.constraintEqualToAnchor(subjectField.centerYAnchor),
            // and its trailing anchor is constrained to the subject field's margin trailing anchor
            characterNumberLabel.trailingAnchor.constraintEqualToAnchor(subjectField.layoutMarginsGuide.trailingAnchor)
        ]
        
        // Activate our constraints
        NSLayoutConstraint.activateConstraints(constraints)
    }
    
    
    // MARK: Navigation Bar Item Methods
    
    func cancel() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    func next() {
        
    }
    
}


extension NewGroupViewController: UITextFieldDelegate {
    
}
