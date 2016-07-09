//
//  ContactsViewController.swift
//  V
//
//  Created by Dulio Denis on 7/5/16.
//  Copyright © 2016 Dulio Denis. All rights reserved.
//

import UIKit
import CoreData
import Contacts
import ContactsUI

class ContactsViewController: UIViewController, ContextViewController {

    // in order to fulfill the ContextVC Protocol
    var context: NSManagedObjectContext?
    
    private let tableView = UITableView(frame: CGRectZero, style: .Plain)
    private let cellIdentifier = "ContactCell"
    
    private var fetchedResultsController: NSFetchedResultsController?
    private var fetchedResultsDelegate: NSFetchedResultsControllerDelegate?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.topItem?.title = "All Contacts"
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "add"), style: .Plain, target: self, action: "newContact")
        
        // Account for the Navigation Bar
        automaticallyAdjustsScrollViewInsets = false
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        tableView.tableFooterView = UIView(frame: CGRectZero)
        
        fillViewWith(tableView)
        
        // if we have a context
        if let context = context {
            // set-up a request of the Contact instances
            let request = NSFetchRequest(entityName: "Contact")
            // with last name, first name sorting
            request.sortDescriptors = [
                NSSortDescriptor(key: "lastName", ascending: true),
                NSSortDescriptor(key: "firstName", ascending: true)
            ]
            
            // initialize the fetched results controller with a sort letter section
            fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: "sortLetter", cacheName: nil)
            
            // initialize the fetched results delegate
            fetchedResultsDelegate = TableViewFetchedResultsDelegate(tableView: tableView, displayer: self)
            // and set the delegate attribute to the fetched results controller
            fetchedResultsController?.delegate = fetchedResultsDelegate
            
            // try to perform the fetch on the fetched results controller in a do-catch statement
            do {
                try fetchedResultsController?.performFetch()
            } catch {
                print("ContactsViewController: There was a problem fetching.")
            }
        }
        
    }
    
    
    func newContact() {
        print("New Contact")
    }

}
