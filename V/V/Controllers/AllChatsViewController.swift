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
        
        // setup fetched results controller to manage the data and sync to the tableview
        // first safely unwrap the context optional
        if let contextExists = context {
            // if we have a context then setup a fetch request to get all the chat instances
            let request = NSFetchRequest(entityName: "Chat")
            // with a sort of last message time attribute
            request.sortDescriptors = [NSSortDescriptor(key: "lastMessageTime", ascending: false)]
            
            // set up fetched results controller with the initializer using the request and context
            fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: contextExists, sectionNameKeyPath: nil, cacheName: nil)
            
            // attempt a fetch
            do {
                try fetchedResultsController?.performFetch()
            } catch {
                print("Error fetching results.")
            }

        }
    }
    

    func newChat() {
        
    }
}
