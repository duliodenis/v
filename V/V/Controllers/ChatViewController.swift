//
//  ChatViewController.swift
//  V
//
//  Created by Dulio Denis on 4/11/16.
//  Copyright © 2016 Dulio Denis. All rights reserved.
//

import UIKit
import CoreData

class ChatViewController: UIViewController {

    // Instatiate a tableView with grouped sections to accomodate the date sections
    private let tableView = UITableView(frame: CGRectZero, style: .Grouped)
    private let newMessageField = UITextView()
    
    // a dictionary with a date as the key and an array of messages as the value
    private var sections = [NSDate: [Message]]()
    
    // and array of dates to hold all the keys of the dictionary
    private var dates = [NSDate]()
    private let cellIdentifier = "Cell"
    
    // for when the Keyboard pops up
    private var bottomConstraint: NSLayoutConstraint!
    
    // an optional Core Data Managed Object Context attribute
    var context: NSManagedObjectContext?
    
    // chat attribute to access our chat
    var chat: Chat?
    
    // private enum to keep track of any issues getting chat instance back from Core Data
    private enum Error: ErrorType {
        case NoChat
        case NoContext
    }
    
    
    // MARK: View Lifecycle Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Fetch any Messages from the persistent store and add them to the view
        do {
            // confirm we have a valid chat and context otherwise throw an error
            guard let chat = chat else { throw Error.NoChat }
            guard let context = context else { throw Error.NoContext }
            
            let request = NSFetchRequest(entityName: "Message")
            
            // add a sort descriptor using a descending timestamp as a key
            request.sortDescriptors = [NSSortDescriptor(key: "timestamp", ascending: false)]
            
            if let result = try context.executeFetchRequest(request) as? [Message] {
                for message in result {
                    addMessage(message)
                }
            }
        } catch {
            print("Could not fetch.")
        }
        
        // ensure the VC doesn't automatically adjust scroll view insets
        automaticallyAdjustsScrollViewInsets = false
        
        // Add a new message area
        let newMessageArea = UIView()
        newMessageArea.backgroundColor = UIColor.lightGrayColor()
        newMessageArea.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(newMessageArea)
        
        // Add the new Message Field
        newMessageField.translatesAutoresizingMaskIntoConstraints = false
        newMessageArea.addSubview(newMessageField)
        
        // turn off scrolling since its a TextView
        newMessageField.scrollEnabled = false
        
        // add a Message Send button 
        let sendButton = UIButton()
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        newMessageArea.addSubview(sendButton)
        
        // add a title to the button and a content hugging priority
        sendButton.setTitle("Send", forState: .Normal)
        sendButton.setContentHuggingPriority(251, forAxis: .Horizontal)
        // also set the send button's compression resistance priority above the default
        sendButton.setContentCompressionResistancePriority(751, forAxis: .Horizontal)
        // add a target to the button
        sendButton.addTarget(self, action: Selector("tappedSend:"), forControlEvents: .TouchUpInside)
        
        // Define and activate the bottom constraint
        bottomConstraint = newMessageArea.bottomAnchor.constraintEqualToAnchor(view.bottomAnchor)
        bottomConstraint.active = true
        
        // Add new message area's constraints (including inner UITextView and UIButton)
        let newMessageAreaConstraints: [NSLayoutConstraint] = [
            newMessageArea.leadingAnchor.constraintEqualToAnchor(view.leadingAnchor),
            newMessageArea.trailingAnchor.constraintEqualToAnchor(view.trailingAnchor),
            newMessageField.leadingAnchor.constraintEqualToAnchor(newMessageArea.leadingAnchor, constant: 10),
            newMessageField.centerYAnchor.constraintEqualToAnchor(newMessageArea.centerYAnchor),
            sendButton.trailingAnchor.constraintEqualToAnchor(newMessageArea.trailingAnchor, constant: -10),
            newMessageField.trailingAnchor.constraintEqualToAnchor(sendButton.leadingAnchor, constant: -10),
            sendButton.centerYAnchor.constraintEqualToAnchor(newMessageField.centerYAnchor),
            newMessageArea.heightAnchor.constraintEqualToAnchor(newMessageField.heightAnchor, constant: 20)
        ]
        
        // And activate them
        NSLayoutConstraint.activateConstraints(newMessageAreaConstraints)
        
        // register the cell identifier of the tableView and use the Custom ChatCell
        tableView.registerClass(MessageCell.self, forCellReuseIdentifier: cellIdentifier)
        
        // set to be the delegate to the tableView's data source and delegate methods
        tableView.dataSource = self
        tableView.delegate = self
        
        // add an estimated row height
        tableView.estimatedRowHeight = 44
        
        // Remove the seperator line from the tableView
        tableView.separatorStyle = .None
        
        // Add a background to the tableView
        tableView.backgroundView = UIImageView(image: UIImage(named: "ChatBackground"))
        tableView.backgroundView?.contentMode = .ScaleAspectFill
        
        // dynamically resize section header (with an estimate)
        tableView.sectionHeaderHeight = UITableViewAutomaticDimension
        tableView.estimatedSectionHeaderHeight = 25
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        
        // Constraints to have the tableView take up the view
        let tableViewConstraints: [NSLayoutConstraint] = [
            tableView.topAnchor.constraintEqualToAnchor(topLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraintEqualToAnchor(view.leadingAnchor),
            tableView.trailingAnchor.constraintEqualToAnchor(view.trailingAnchor),
            tableView.bottomAnchor.constraintEqualToAnchor(newMessageArea.topAnchor)]
        
        // Activate the tableView constraints
        NSLayoutConstraint.activateConstraints(tableViewConstraints)
        
        // Add an NSNotification Listener for the Keyboard showing and hiding
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name: UIKeyboardWillHideNotification, object: nil)
        
        // get our mainContext
        if let mainContext = context?.parentContext ?? context {
            // listen for context objects did change and call contextUpdated() when it does
            NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("contextUpdated:"), name: NSManagedObjectContextObjectsDidChangeNotification, object: mainContext)
        }
        
        // Add single tap gesture recognizer to dismiss keyboard
        let tapRecognizer = UITapGestureRecognizer(target: self, action: "handleSingleTap:")
        tapRecognizer.numberOfTapsRequired = 1 // single tap
        view.addGestureRecognizer(tapRecognizer)
    }
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        // use our tableView extension to scroll to the bottom
        tableView.scrollToBottom()
    }
    
    
    // MARK: Keyboard Will Show and Hide Selector Functions
    
    func keyboardWillShow(notification: NSNotification) {
        updateBottomConstraint(notification)
    }
    
    
    func keyboardWillHide(notification: NSNotification) {
        updateBottomConstraint(notification)
    }
    
    
    // MARK: Gesture Recognizer Function
    
    func handleSingleTap(tapRecognizer: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    
    // MARK: Updating the Bottom Constraint Function
    
    func updateBottomConstraint(notification: NSNotification) {
        // optional chaining to ensure we have all three values
        if let userInfo = notification.userInfo,
            frame = userInfo[UIKeyboardFrameEndUserInfoKey]?.CGRectValue,
            animationDuration = userInfo[UIKeyboardAnimationDurationUserInfoKey]?.doubleValue {
                let newFrame = view.convertRect(frame, fromView: (UIApplication.sharedApplication().delegate?.window)!)
                bottomConstraint.constant = newFrame.origin.y - CGRectGetHeight(view.frame) // the height of the keyboard
                UIView.animateWithDuration(animationDuration, animations: {
                    self.view.layoutIfNeeded() // redraw if necessary
                })
                tableView.scrollToBottom()
        }
    }
    
    
    // MARK: Send Message
    
    func tappedSend(button: UIButton) {
        // Ensure the new message field has some text in it before proceeding
        guard let text = newMessageField.text where text.characters.count > 0 else { return }
        
        // check temporary context
        checkTemporaryContext()
        
        // Guard against a nil context
        guard let context = context else { return }
        
        // Create a new instance of the entity message from our context
        guard let message = NSEntityDescription.insertNewObjectForEntityForName("Message", inManagedObjectContext: context) as? Message else { return }
        
        // push the new text inputted into the new message object
        message.text = text
        // this is not an incoming message
        message.isIncoming = false
        
        // add the timestamp
        message.timestamp = NSDate()
        
        // add the message
        addMessage(message)
        
        // save to context
        do {
            try context.save()
        } catch {
            print("Problem Saving to Context.")
            return
        }
        
        // reset the new message text field
        newMessageField.text = ""
        
        // reload data in the tableView
        tableView.reloadData()
        
        // resign first responder in order to hide the keyboard after sending
        view.endEditing(true)
        
        // then use our tableView extension to scroll to the bottom
        tableView.scrollToBottom()
    }
    
    
    // MARK: Add Message 
    //       takes a message parameter
    
    func addMessage(message: Message) {
        // ensure we have a timestamp in our message - otherwise pass thru
        guard let date = message.timestamp else { return }
        
        // create a calendar instance
        let calendar = NSCalendar.currentCalendar()
        let startDay = calendar.startOfDayForDate(date)
        
        // get correct value for the current start day
        var messages = sections[startDay]
        
        // if messages are nil then append start day to the dates array
        if messages == nil {
            dates.append(startDay)
            
            // sort dates array using the sort closure
            dates = dates.sort({ $0.earlierDate($1) == $0 })
            
            // initialize the messages array and specify it as holding the messages instance
            messages = [Message]()
        }
        // append the new message to the messages array
        messages!.append(message)
        
        // and sort in place based on the timestamp attribute
        messages!.sortInPlace{ $0.timestamp!.earlierDate($1.timestamp!) == $0.timestamp! }
        
        // update the value to the start day key with the added message
        sections[startDay] = messages
    }
    
    
    // MARK: Handle Context Updates
    
    func contextUpdated(notification: NSNotification) {
        // access user info from the NSInsertedObjectsKey to get all the instance that have been
        // inserted into CoreData
        guard let set = (notification.userInfo![NSInsertedObjectsKey] as? NSSet) else { return }
        // convert the set into an array
        let objects = set.allObjects
        
        // and loop through each element in the array of objects
        for object in objects {
            // confirm the object is a message type
            guard let message = object as? Message else { continue }
            // ensure that the message has the same chat object id
            if message.chat?.objectID == chat?.objectID {
                // if it does call our addMessage() method
                addMessage(message)
            }
        }
        
        // reload the tabelView and scroll to the bottom
        tableView.reloadData()
        tableView.scrollToBottom()
    }
    
    
    // MARK: Check Temporary Context
    
    func checkTemporaryContext() {
        // ensure we have a value for our mainContext and our chat instance
        if let mainContext = context?.parentContext, chat = chat {
            // assign context to a tempContext constant
            let tempContext = context
            // update the context to the mainContext
            context = mainContext
            // do a do-catch statement to attempt to save using our temp context
            do {
                try tempContext?.save()
            } catch {
                print("Error Saving TempContext.")
            }
            // update our chat attribute with the objectWithID method
            self.chat = mainContext.objectWithID(chat.objectID) as? Chat
        }
    }
    
}


// MARK: UITableView Data Source Protocol Methods in a ChatViewController Extension

extension ChatViewController: UITableViewDataSource {
    
    // MARK: Get Message
    //       takes a single parameter for the specific section required
    //       returns an array of messages
    
    func getMessages(section: Int) -> [Message] {
        // get the date for the section using the dates array
        let date = dates[section]
        // return the messages from the sections dictionary using the date as the key
        return sections[date]!
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return dates.count
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return getMessages(section).count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! MessageCell
        
        let messages = getMessages(indexPath.section)
        let message = messages[indexPath.row]
        cell.messageLabel.text = message.text
        cell.incoming(message.isIncoming)
        
        cell.backgroundColor = UIColor.clearColor()
        
        return cell
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        // initialize an instance of a UIView
        let newView = UIView()
        // with a clear background color
        newView.backgroundColor = UIColor.clearColor()
        // and for some padding make a padding view
        let paddingView = UIView()
        // which we add as a subview to our new view
        newView.addSubview(paddingView)
        // and turn of auto resizing mask into constraints
        paddingView.translatesAutoresizingMaskIntoConstraints = false
        
        // initialize a new UILabel to be used as a date label
        let dateLabel = UILabel()
        // and add datelabel to the padding view
        paddingView.addSubview(dateLabel)
        // turn off autoresizing mask into constraints for the date label too
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Setup constraints for the header
        // add some padding to the padding view as the name suggests - height 5 / width 10
        let constraints: [NSLayoutConstraint] = [
            paddingView.centerXAnchor.constraintEqualToAnchor(newView.centerXAnchor),
            paddingView.centerYAnchor.constraintEqualToAnchor(newView.centerYAnchor),
            dateLabel.centerXAnchor.constraintEqualToAnchor(paddingView.centerXAnchor),
            dateLabel.centerYAnchor.constraintEqualToAnchor(paddingView.centerYAnchor),
            paddingView.heightAnchor.constraintEqualToAnchor(dateLabel.heightAnchor, constant: 5),
            paddingView.widthAnchor.constraintEqualToAnchor(dateLabel.widthAnchor, constant: 10),
            newView.heightAnchor.constraintEqualToAnchor(paddingView.heightAnchor)
        ]
        
        // activate the array of constraints
        NSLayoutConstraint.activateConstraints(constraints)

        // Setup a Date Formatter for the date label
        let formatter = NSDateFormatter()
        // specify a format of Month Day Year
        formatter.dateFormat = "MMM dd, YYYY"
        
        // then update the date label's text attribute using the formatter using the proper date
        dateLabel.text = formatter.stringFromDate(dates[section])
        
        // customize the padding view - with a nice rounded edges
        paddingView.layer.cornerRadius = 10
        // clipping any sublayers
        paddingView.layer.masksToBounds = true
        // and adding a sweet Nephritis Green
        paddingView.backgroundColor = UIColor(red: 39/255, green: 174/255, blue: 96/255, alpha: 1)
        
        // return the new view
        return newView
    }
    
    
    // Configure some spacing for the footer
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
}


// MARK: UITableView Delegate Protocol Methods in a ChatViewController Extension

extension ChatViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, shouldHighlightRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }
    
}