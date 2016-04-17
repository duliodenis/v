//
//  ChatViewController.swift
//  V
//
//  Created by Dulio Denis on 4/11/16.
//  Copyright © 2016 Dulio Denis. All rights reserved.
//

import UIKit

class ChatViewController: UIViewController {

    private let tableView = UITableView()
    private let newMessageField = UITextView()
    
    private var messages = [Message]()
    private let cellIdentifier = "Cell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // initial message data for testing
        var localIncoming = true
        
        for i in 0...10 {
            let m = Message()
            m.text = String(i)
            m.incoming = localIncoming
            localIncoming = !localIncoming
            messages.append(m)
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
        
        // Add new message area's constraints (including inner UITextView and UIButton)
        let newMessageAreaConstraints: [NSLayoutConstraint] = [
            newMessageArea.leadingAnchor.constraintEqualToAnchor(view.leadingAnchor),
            newMessageArea.trailingAnchor.constraintEqualToAnchor(view.trailingAnchor),
            newMessageArea.bottomAnchor.constraintEqualToAnchor(view.bottomAnchor),
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
    }
    
}


// MARK: UITableView Data Source Protocol Methods in a ChatViewController Extension

extension ChatViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! ChatCell
        
        let message = messages[indexPath.row]
        cell.messageLabel.text = message.text
        cell.incoming(message.incoming)
        
        return cell
    }
    
}


// MARK: UITableView Delegate Protocol Methods in a ChatViewController Extension

extension ChatViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, shouldHighlightRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }
    
}