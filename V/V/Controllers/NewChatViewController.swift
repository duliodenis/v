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
        
        // unwrap context to confirm not nil
        if let context = context {
            // setup a request for Contact objects
            let request = NSFetchRequest(entityName: "Contact")
            
            // using sort descriptors have the request order last name then first name attributes
            request.sortDescriptors = [
                NSSortDescriptor(key: "lastName", ascending: true),
                NSSortDescriptor(key: "firstName", ascending: true)
            ]
            
            // set the fetched results controller to have multiple sections and a cache
            fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: "sortLetter", cacheName: "NewChatViewController")
            
            // try to perform the fetch inside a do {} catch statement
            do {
                try fetchedResultsController?.performFetch()
            } catch {
                print("Problem fetching New Chats.")
            }
        }
    }
    
    
    // MARK: Cancel Right Bar Button Item Method
    
    func cancel() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    // MARK: Configure Cell Helper Method
    
    func configureCell(cell: UITableViewCell, atIndexPath indexPath: NSIndexPath) {
        
        // get the relevant contact using the fetched results controller by getting the object at the indexPath
        guard let contact = fetchedResultsController?.objectAtIndexPath(indexPath) as? Contact else { return }
        // update the cell's text label with the computed attribute of the contact's full name
        cell.textLabel?.text = contact.fullName
    }
    
}
