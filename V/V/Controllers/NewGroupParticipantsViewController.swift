//
//  NewGroupParticipantsViewController.swift
//  V
//
//  Created by Dulio Denis on 6/18/16.
//  Copyright © 2016 Dulio Denis. All rights reserved.
//

import UIKit
import CoreData

class NewGroupParticipantsViewController: UIViewController {
    
    var context: NSManagedObjectContext?
    var chat: Chat?
    // set this when we create our new instance of our VC
    var chatCreationDelegate: ChatCreationDelegate?
    
    // Used to search for contacts
    private var searchField: UITextField!
    
    // tableView for search result items
    private let tableView = UITableView(frame: CGRectZero, style: .Plain)
    private let cellIdentifier = "ContactCell"
    
    // attribute to store all of our Contacts to be displayed
    private var displayedContacts = [Contact]()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set the title
        title = "Add Participants"
        
        // create the Nav Right Bar Button Item with a target action
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Create", style: .Plain, target: self, action: "createChat")
        // and set it to not show initially
        showCreateButton(false)
        
        // the view controller should not automatically adjust its scroll views
        // since we are inside a UI Navigation Controller
        automaticallyAdjustsScrollViewInsets = false
        
        // register the tableView
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        // set the tableView data source to self
        tableView.dataSource = self
        // set-up a UIView to have a footer view under the tableview
        tableView.tableFooterView = UIView(frame: CGRectZero)
        
        // use our helper method to create the searchField
        searchField = createSearchField()
        
        // make our searchField the tableView's header
        tableView.tableHeaderView = searchField
        
        // use our UIVC extension to fill the view with our tableView
        fillViewWith(tableView)
    }
    
    
    // MARK: Private Helper Method for searchField
    
    private func createSearchField() -> UITextField {
        // instantiate a UITextField using a Frame with only a height of 50
        let searchField = UITextField(frame: CGRect(x: 0, y: 0, width: 0, height: 50))
        // set a background color to our new UITextField with a custom RGB
        searchField.backgroundColor = UIColor(red: 220/255, green: 220/255, blue: 220/225, alpha: 1)
        // set a placeholder
        searchField.placeholder = "Type contact name"
        
        // make a left side holder view and assign it to the searchField leftView attribute
        // with an .Always display mode
        let holderView = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        searchField.leftView = holderView
        searchField.leftViewMode = .Always
        
        // set up an image for our left side holder view ignoring the image asset's color
        let contactImage = UIImage(named: "contact_icon")?.imageWithRenderingMode(.AlwaysTemplate)
        // set up an ImageView to hold our image
        let contactImageView = UIImageView(image: contactImage)
        // and set a tint color on the image view since we removed the asset's color
        contactImageView.tintColor = UIColor.darkGrayColor()
        
        // Add our contactImageView as a subview to our holder view
        holderView.addSubview(contactImageView)
        
        // shutoff autoresizing mask translation into constrains so we can set them thru auto layout
        contactImageView.translatesAutoresizingMaskIntoConstraints = false
        
        // Setup Auto Layout Constraints
        let constraints: [NSLayoutConstraint] = [
            // width & height is 20 less than the holder view to add a border to the sides & top/bottom
            contactImageView.widthAnchor.constraintEqualToAnchor(holderView.widthAnchor, constant: -20),
            contactImageView.heightAnchor.constraintEqualToAnchor(holderView.heightAnchor, constant: -20),
            // center the contact image inside the holder view
            contactImageView.centerXAnchor.constraintEqualToAnchor(holderView.centerXAnchor),
            contactImageView.centerYAnchor.constraintEqualToAnchor(holderView.centerYAnchor)
        ]
        
        // activate the constraints with the constraint array
        NSLayoutConstraint.activateConstraints(constraints)
        
        // return our searchField
        return searchField
    }
    
    
    // MARK: Dynamically Enable / Disable Right Bar Button Item
    
    private func showCreateButton(show: Bool) {
        // if show is true: tint and enable the right bar button item
        if show {
            navigationItem.rightBarButtonItem?.tintColor = view.tintColor
            navigationItem.rightBarButtonItem?.enabled = true
        // otherwise update the tint and disable
        } else {
            navigationItem.rightBarButtonItem?.tintColor = UIColor.lightGrayColor()
            navigationItem.rightBarButtonItem?.enabled = false
        }
    }

}


extension NewGroupParticipantsViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // use the number of displayed contacts as the number of rows in the tableView
        return displayedContacts.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // make a cell for the indexPath in question
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath)
        // get the contact at this indexPath.row
        let contact = displayedContacts[indexPath.row]
        
        // assign the contact full name to the cell's text label
        cell.textLabel?.text = contact.fullName
        // set the selection style to none to remove highlighting
        cell.selectionStyle = .None
        // return the new cell
        return cell
    }
    
}
