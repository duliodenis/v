//
//  NewChatViewController.swift
//  V
//
//  Created by Dulio Denis on 5/23/16.
//  Copyright © 2016 Dulio Denis. All rights reserved.
//

import UIKit
import CoreData

class NewChatViewController: UIViewController {
    
    var context: NSManagedObjectContext?
    private var fetchedResultsController: NSFetchedResultsController?
    
    private let tableView = UITableView(frame: CGRectZero, style: .Plain)
    private let cellIdentifier = "ContectCell"
    
    
    // MARK: View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the title on the Nav Bar
        title = "New Chat"
        // set-up the cancel bar button item
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Cancel", style: .Plain, target: self, action: "cancel")
        // prevent our nav bar from messing up our table view
        automaticallyAdjustsScrollViewInsets = false
        
        // setup table view by registering it
        tableView.registerClass(UITableView.self, forCellReuseIdentifier: cellIdentifier)
        // turn off auto resising mask so we can use constraints with our table view
        tableView.translatesAutoresizingMaskIntoConstraints = false
        // add it as a subview
        view.addSubview(tableView)
        
        // setup constraints for the table view
        let tableViewConstraints: [NSLayoutConstraint] = [
            tableView.topAnchor.constraintEqualToAnchor(topLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraintEqualToAnchor(view.leadingAnchor),
            tableView.trailingAnchor.constraintEqualToAnchor(view.trailingAnchor),
            tableView.bottomAnchor.constraintEqualToAnchor(bottomLayoutGuide.topAnchor)
        ]
        // and add the constraints
        NSLayoutConstraint.activateConstraints(tableViewConstraints)
    }
    
    
    // MARK: Cancel Right Bar Button Item Method
    
    func cancel() {
        dismissViewControllerAnimated(true, completion: nil)
    }
}
