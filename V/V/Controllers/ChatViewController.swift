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
        
        // register the cell identifier of the tableView and use the Custom ChatCell
        tableView.registerClass(ChatCell.self, forCellReuseIdentifier: cellIdentifier)
        
        // set to be the delegate to the tableView's data source and delegate methods
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        
        // Constraints to have the tableView take up the view
        let tableViewConstraints: [NSLayoutConstraint] = [
            tableView.topAnchor.constraintEqualToAnchor(view.topAnchor),
            tableView.leadingAnchor.constraintEqualToAnchor(view.leadingAnchor),
            tableView.trailingAnchor.constraintEqualToAnchor(view.trailingAnchor),
            tableView.bottomAnchor.constraintEqualToAnchor(view.bottomAnchor)]
        
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