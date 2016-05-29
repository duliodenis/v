//
//  AllChatsViewController.swift
//  V
//
//  Created by Dulio Denis on 5/17/16.
//  Copyright © 2016 Dulio Denis. All rights reserved.
//

import UIKit
import CoreData

class AllChatsViewController: UIViewController, TableViewFetchedResultsDisplayer {

    var context: NSManagedObjectContext?
    private var fetchedResultsController: NSFetchedResultsController?
    
    private let tableView = UITableView(frame: CGRectZero, style: .Plain)
    private let cellIdentifier = "MessageCell"
    
    private var fetchedResultsDelegate: NSFetchedResultsControllerDelegate?
    
    
    // MARK: View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set navbar title and new chat bar button item
        title = "Chats"
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "new-chat"), style: .Plain, target: self, action: "newChat")
        
        // ensure the tableview isn't distorted due to the navbar
        automaticallyAdjustsScrollViewInsets = false
        
        // set ourself as the data source and delegate of the tableview - see extensions
        tableView.dataSource = self
        tableView.delegate = self
        
        // tableView setup: register class, initialize tableview footer, allow our use of auto-layout
        tableView.registerClass(ChatCell.self, forCellReuseIdentifier: cellIdentifier)
        tableView.tableFooterView = UIView(frame: CGRectZero)

        // add tableView with activated constraints
        fillViewWith(tableView)
        
        // setup fetched results controller to manage the data and sync to the tableview
        // first safely unwrap the context optional
        if let contextExists = context {
            // if we have a context then setup a fetch request to get all the chat instances
            let request = NSFetchRequest(entityName: "Chat")
            // with a sort of last message time attribute
            request.sortDescriptors = [NSSortDescriptor(key: "lastMessageTime", ascending: false)]
            
            // set up fetched results controller with the initializer using the request and context
            fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: contextExists, sectionNameKeyPath: nil, cacheName: nil)
            
            // set the fetchedResultsDelegate to a TableViewFetchedResultsDelegate instance
            fetchedResultsDelegate = TableViewFetchedResultsDelegate(tableView: tableView, displayer: self)
            
            // set the fetchedResultsDelegate as the delegate of the fetched results controller
            fetchedResultsController?.delegate = fetchedResultsDelegate
            
            // attempt a fetch
            do {
                try fetchedResultsController?.performFetch()
            } catch {
                print("Error fetching results.")
            }
        }
        
        // call test data function
        testData()
    }
    

    // MARK: New Chat Function
    
    func newChat() {
        // Get a New Chat View Controller
        let vc = NewChatViewController()
        // and assign the context to the new VC context attribute
        vc.context = context
        // then get a new Nav Controller with a NewChat VC as the root
        let navVC = UINavigationController(rootViewController: vc)
        // and present this Nav Controller
        presentViewController(navVC, animated: true, completion: nil)
    }
    
    
    // MARK: Test Data Function
    
    func testData() {
        // ensure there is a context
        guard let contextExists = context else { return }
        // generate a brand new chat instance
        let chat = NSEntityDescription.insertNewObjectForEntityForName("Chat", inManagedObjectContext: contextExists) as? Chat
    }
    
    
    // MARK: Configure Cell Helper Method
    
    func configureCell(cell: UITableViewCell, atIndexPath indexPath: NSIndexPath) {
        // confirm we have a ChatCell
        let cell = cell as! ChatCell
        
        // use a guard statement to access the fetched results controller and get the object at index path
        guard let chat = fetchedResultsController?.objectAtIndexPath(indexPath) as? Chat else { return }
        
        // hard code some message for now
        let formatter = NSDateFormatter()
        formatter.dateFormat = "MM/dd/YY"
        cell.nameLabel.text = "Cindy"
        cell.dateLabel.text = formatter.stringFromDate(NSDate())
        cell.messageLabel.text = "Hey!"
    }
}


extension AllChatsViewController: UITableViewDataSource {
    
    // MARK: UITableViewDataSource Methods
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // determine how many sections using the fetched results controller (else zero if nil)
        return fetchedResultsController?.sections?.count ?? 0
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // guard against a nil fetched results controller and return zero
        guard let sections = fetchedResultsController?.sections else { return 0 }
        // else index into the current section
        let currentSection = sections[section]
        // and return the number of objects in the current section
        return currentSection.numberOfObjects
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // dequeue a cell using the cellIdentifier
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath)
        // use the helper method to configure
        configureCell(cell, atIndexPath: indexPath)
        // return that cell
        return cell
    }
}


extension AllChatsViewController: UITableViewDelegate {
    
    // MARK: UITableViewDelegate Methods
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        //return 100 points
        return 100
    }
    
    
    func tableView(tableView: UITableView, shouldHighlightRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // highlight when tapped
        return true
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        guard let chat = fetchedResultsController?.objectAtIndexPath(indexPath) as? Chat else { return }
    }
}
