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
    }
    
}


extension NewGroupViewController: UITextFieldDelegate {
    
}
