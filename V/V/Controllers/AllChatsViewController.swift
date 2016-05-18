//
//  AllChatsViewController.swift
//  V
//
//  Created by Dulio Denis on 5/17/16.
//  Copyright © 2016 Dulio Denis. All rights reserved.
//

import UIKit
import CoreData

class AllChatsViewController: UIViewController {

    var context: NSManagedObjectContext?
    private var fetchedResultsController: NSFetchedResultsController?
    
    private let tableView = UITableView(frame: CGRectZero, style: .Plain)
    private let cellIdentifier = "MessageCell"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set navbar title and new chat bar button item
        title = "Chats"
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "new_chat"), style: .Plain, target: self, action: "newChat")
        
        // ensure the tableview isn't distorted due to the navbar
        automaticallyAdjustsScrollViewInsets = false
        
        // tableView setup: register class, initialize tableview footer, allow our use of auto-layout
        tableView.registerClass(ChatCell.self, forCellReuseIdentifier: cellIdentifier)
        tableView.tableFooterView = UIView(frame: CGRectZero)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        
        // add constraints to the tableview
        let tableViewConstraints: [NSLayoutConstraint] = [
            tableView.topAnchor.constraintEqualToAnchor(topLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraintEqualToAnchor(view.leadingAnchor),
            tableView.trailingAnchor.constraintEqualToAnchor(view.trailingAnchor),
            tableView.bottomAnchor.constraintEqualToAnchor(bottomLayoutGuide.topAnchor)
        ]
        
        // activate the constraints
        NSLayoutConstraint.activateConstraints(tableViewConstraints)
    }
    

    func newChat() {
        
    }
}
