//
//  ChatViewController.swift
//  V
//
//  Created by Dulio Denis on 4/11/16.
//  Copyright © 2016 Dulio Denis. All rights reserved.
//

import UIKit

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
    
    
    // MARK: View Lifecycle Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // initial message data for testing
        var localIncoming = true
        
        // generate a test date for the timestamp
        var date = NSDate(timeIntervalSince1970: 1100000000)
        
        for i in 0...10 {
            let m = Message()
            m.text = String(i)
            m.timestamp = date
            m.incoming = localIncoming
            localIncoming = !localIncoming
            addMessage(m)
            
            // increment the day every other test message
            if i%2 == 0 {
                date = NSDate(timeInterval: 60*60*24, sinceDate: date)
            }
        }
        
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
        tableView.registerClass(ChatCell.self, forCellReuseIdentifier: cellIdentifier)
        
        // set to be the delegate to the tableView's data source and delegate methods
        tableView.dataSource = self
        tableView.delegate = self
        
        // add an estimated row height
        tableView.estimatedRowHeight = 44
        
        // Remove the seperator line from the tableView
        tableView.separatorStyle = .None
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        
        // Constraints to have the tableView take up the view
        let tableViewConstraints: [NSLayoutConstraint] = [
            tableView.topAnchor.constraintEqualToAnchor(view.topAnchor),
            tableView.leadingAnchor.constraintEqualToAnchor(view.leadingAnchor),
            tableView.trailingAnchor.constraintEqualToAnchor(view.trailingAnchor),
            tableView.bottomAnchor.constraintEqualToAnchor(newMessageArea.topAnchor)]
        
        // Activate the tableView constraints
        NSLayoutConstraint.activateConstraints(tableViewConstraints)
        
        // Add an NSNotification Listener for the Keyboard showing and hiding
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name: UIKeyboardWillHideNotification, object: nil)
        
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
    
    
    // MARK: Action Functions
    
    func tappedSend(button: UIButton) {
        // Ensure the new message field has some text in it before proceeding
        guard let text = newMessageField.text where text.characters.count > 0 else { return }
        
        // Create a new instance of message
        let message = Message()
        // push the new text inputted into the new message object
        message.text = text
        // this is not an incoming message
        message.incoming = false
        
        // add the timestamp
        message.timestamp = NSDate()
        
        // add the message
        addMessage(message)
        
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
            // initialize the messages array and specify it as holding the messages instance
            messages = [Message]()
        }
        // append the new message to the messages array
        messages!.append(message)
        // update the value to the start day key with the added message
        sections[startDay] = messages
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
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! ChatCell
        
        let messages = getMessages(indexPath.section)
        let message = messages[indexPath.row]
        cell.messageLabel.text = message.text
        cell.incoming(message.incoming)
        
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