//
//  AllChatsViewController.swift
//  V
//
//  Created by Dulio Denis on 5/17/16.
//  Copyright © 2016 Dulio Denis. All rights reserved.
//

import UIKit
import CoreData

class AllChatsViewController: UIViewController, TableViewFetchedResultsDisplayer, ChatCreationDelegate, ContextViewController {

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
        
        // initialize table header view with our createHeader() function
        tableView.tableHeaderView = createHeader()

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
        
        // create a context for the new chat VC using the NSManagedObjectContext initializer
        let chatContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        // make the chatContext a child of the current context
        chatContext.parentContext = context
        // assign the child context to the new VC context attribute
        vc.context = chatContext
        
        // assign the ChatCreationDelegate to self
        vc.chatCreationDelegate = self
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
        
        // use a guard statement to ensure we have a chat participant otherwise return
        guard let contact = chat.participants?.anyObject() as? Contact else { return }
        
        // use a guard statment to access our last message and get the timestamp and text to update the cell
        guard let lastMessage = chat.lastMessage, timestamp = lastMessage.timestamp, text = lastMessage.text else { return }
        
        // hard code some message for now
        let formatter = NSDateFormatter()
        formatter.dateFormat = "MM/dd/YY"
        cell.nameLabel.text = contact.fullName
        cell.dateLabel.text = formatter.stringFromDate(timestamp)
        cell.messageLabel.text = text
    }
    
    
    // MARK: Conform to the ChatCreationDelegate
    
    func created(chat chat: Chat, inContext context: NSManagedObjectContext) {
        // generate a ChatVC instance
        let vc = ChatViewController()
        // assign the context and chat attributes which are passed to us to the new ChatVC
        vc.context = context
        vc.chat = chat
        
        // hide tabBarController
        vc.hidesBottomBarWhenPushed = true
        
        // display the new ChatVC with a nav pushVC
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    // MARK: Create Header View
    
    private func createHeader() -> UIView {
        // generate a UIView instance
        let header = UIView()
        // generate a UIButton instance that will be in the header
        let newGroupButton = UIButton()
        // shutoff the autoresizing mask translation into constrains so we can set them
        newGroupButton.translatesAutoresizingMaskIntoConstraints = false
        // add the new group button as a subview to the header view
        header.addSubview(newGroupButton)
        
        // add a title to the new group button
        newGroupButton.setTitle("New Group", forState: .Normal)
        // set the title color
        newGroupButton.setTitleColor(view.tintColor, forState: .Normal)
        // set the title font
        newGroupButton.titleLabel?.font = UIFont(name: "AdventPro-Regular", size: 20)
        // and add a target action to the button
        newGroupButton.addTarget(self, action: "newGroupTapped", forControlEvents: .TouchUpInside)
        
        // generate a UIView to be used as a border view
        let border = UIView()
        // shutoff autoresizing mask translation into constrains so we can set them thru auto layout
        border.translatesAutoresizingMaskIntoConstraints = false
        // add the border as a subview to the header
        header.addSubview(border)
        // set the border background color
        border.backgroundColor = UIColor.lightGrayColor()
        
        // set-up our constraints
        let constraints:[NSLayoutConstraint] = [
            // make the height of the new group button the same as that of the header view
            newGroupButton.heightAnchor.constraintEqualToAnchor(header.heightAnchor),
            // tie the new group button's trailing anchor to the header's trailing anchor
            newGroupButton.trailingAnchor.constraintEqualToAnchor(header.layoutMarginsGuide.trailingAnchor),
            // specify a height of 1 for the border view
            border.heightAnchor.constraintEqualToConstant(1),
            // constrain the border's leading & trailing anchor to the headers leading & trailing anchor
            border.leadingAnchor.constraintEqualToAnchor(header.leadingAnchor),
            border.trailingAnchor.constraintEqualToAnchor(header.trailingAnchor),
            // and make the border's bottom anchor equal to the header's bottom anchor
            border.bottomAnchor.constraintEqualToAnchor(header.bottomAnchor)
        ]
        
        // activate the constraints
        NSLayoutConstraint.activateConstraints(constraints)
        
        // Provide the header view with a layout for Auto-Layout Sizing
        // by first invalidating the layout
        header.setNeedsLayout()
        // and force the layout of subviews
        header.layoutIfNeeded()
        
        // get the smallest possible height that satisfies its constraints
        let height = header.systemLayoutSizeFittingSize(UILayoutFittingCompressedSize).height
        
        // update our header's CGRect frame by first making a copy of the current frame
        var frame = header.frame
        // and then updating it with the new calculated height
        frame.size.height = height
        // and copying back the updated frame of the header
        header.frame = frame
        
        // return the header
        return header
    }
    
    
    // MARK: New Group Tapped Action
    
    func newGroupTapped() {
        // instantiate a new NewGroupVC
        let groupVC = NewGroupViewController()
        // instantiate a new NSManagedObjectContext
        let groupVCContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        // set this new NSManagedObjectContext as a child to our current context
        groupVCContext.parentContext = context
        // set the new child context as the context for our group VC
        groupVC.context = groupVCContext
        // set the chat creation delegate of the group VC to be the AllChatsVC instance
        groupVC.chatCreationDelegate = self
        
        // instantiate a UINav Controller
        let navVC = UINavigationController(rootViewController: groupVC)
        
        // present our nav VC
        presentViewController(navVC, animated: true, completion: nil)
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
        // fetch the appropriate chat that was tapped
        guard let chat = fetchedResultsController?.objectAtIndexPath(indexPath) as? Chat else { return }
        
        // initialize the Next View Controller with an instance of a ChatVC
        let nextVC = ChatViewController()
        // set the context and the chat of the Next View Controller
        nextVC.context = context
        nextVC.chat = chat
        
        // hide tabBarController
        nextVC.hidesBottomBarWhenPushed = true
        
        // present the Next VC by pushing into the navigation controller
        navigationController?.pushViewController(nextVC, animated: true)
        // and deselect the selected row in the tableView
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}
