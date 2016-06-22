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
    // attribute that will contain a list of every Contact
    private var allContacts = [Contact]()
    // attribute that will contain the selected Contacts
    private var selectedContacts = [Contact]()
    
    // is the user searching for a contact
    private var isSearching = false
    
    
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
        // and the tableView delegate to self
        tableView.delegate = self
        
        // set-up a UIView to have a footer view under the tableview
        tableView.tableFooterView = UIView(frame: CGRectZero)
        
        // use our helper method to create the searchField
        searchField = createSearchField()
        // and set the searchField delegate to ourself
        searchField.delegate = self
        
        // make our searchField the tableView's header
        tableView.tableHeaderView = searchField
        
        // use our UIVC extension to fill the view with our tableView
        fillViewWith(tableView)
        
        // ensure we have a valid context
        if let context = context {
            // use an NSFetchRequest to get the Contact instances back from Core Data
            let request = NSFetchRequest(entityName: "Contact")
            // sort the request by last name then first name with an array of sort descriptors
            request.sortDescriptors = [
                NSSortDescriptor(key: "lastName", ascending: true),
                NSSortDescriptor(key: "firstName", ascending: true)
            ]
            
            // use a do-catch statement to execute the fetch request to get the contacts back
            do {
                if let result = try context.executeFetchRequest(request) as? [Contact] {
                    // update the display contacts with the result of the fetch request
                    allContacts = result
                }
            } catch {
                print("New Group Participants: there was a problem fetching")
            }
            
        }
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
    
    
    // MARK: Dynamically Enable / Disable the Create Right Bar Button Item
    
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
    
    
    // MARK: endSearch Function
    
    private func endSearch() {
        // display only those contacts we selected
        displayedContacts = selectedContacts
        // reload the tableView
        tableView.reloadData()
    }

    
    // MARK: Create Chat Function
    
    func createChat() {
        // ensure we have valid chat and context attributes
        guard let chat = chat, context = context else { return }
        
        // update the chat partipant set with our array of selected contacts
        chat.participants = NSSet(array: selectedContacts)
        
        // call the chat creation delegate
        chatCreationDelegate?.created(chat: chat, inContext: context)
        // and dismiss ourselves
        dismissViewControllerAnimated(false, completion: nil)
    }
    
}


extension NewGroupParticipantsViewController: UITableViewDataSource {
    // MARK: UITableViewDataSource Methods
    
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


extension NewGroupParticipantsViewController: UITableViewDelegate {
    // MARK: UITableViewDelegate Methods
    
    func tableView(tableView: UITableView, shouldHighlightRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // highlight when user taps on a row
        return true
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // if not searching return
        guard isSearching else { return }
        
        // take the contact from the displayed contacts that was just tapped
        let contact = displayedContacts[indexPath.row]
        // make sure its not already in the selected contacts array
        guard !selectedContacts.contains(contact) else { return }
        // add it to the selected contacts array
        selectedContacts.append(contact)
        
        // remove the selected contact from the pool of all contacts
        allContacts.removeAtIndex(allContacts.indexOf(contact)!)
        
        // reset the search field with an empty string
        searchField.text = ""
        
        // end the search and show the Create nav bar button
        endSearch()
        showCreateButton(true)
    }
}


extension NewGroupParticipantsViewController: UITextFieldDelegate {
    // MARK: UITextFieldDelegate Method
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        // the user is now searching
        isSearching = true
        
        // use a guard statement to test that we have text
        guard let currentText = textField.text else {
            // if we don't have a value - end the search
            endSearch()
            return true
        }
        
        // create a string variable by replacing current text with the strings in the range
        let text = NSString(string: currentText).stringByReplacingCharactersInRange(range, withString: string)
        
        // if we don't have any characters in the resultant string then end the search
        if text.characters.count == 0 {
            endSearch()
            return true
        }
        
        // if we have characters call the filter method on the all contacts array
        // and assign the result to the displayedContacts array
        displayedContacts = allContacts.filter {
            contact in
            // iterate through each contact to determine if we have a match
            let match = contact.fullName.rangeOfString(text) != nil
            return match
        }
        
        // reload the table view
        tableView.reloadData()
        return true
    }
    
}
