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

class ContactsViewController: UIViewController, ContextViewController, ContactSelector {

    // in order to fulfill the ContextVC Protocol
    var context: NSManagedObjectContext?
    
    private let tableView = UITableView(frame: CGRectZero, style: .Plain)
    private let cellIdentifier = "ContactCell"
    
    private var fetchedResultsController: NSFetchedResultsController?
    private var fetchedResultsDelegate: NSFetchedResultsControllerDelegate?
    
    private var searchController: UISearchController?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.topItem?.title = "All Contacts"
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "add"), style: .Plain, target: self, action: "newContact")
        
        // Account for the Navigation Bar
        automaticallyAdjustsScrollViewInsets = false
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        tableView.tableFooterView = UIView(frame: CGRectZero)
        
        // set ourself to be the tableView's delegate and tableView's data source delegate
        tableView.dataSource = self
        tableView.delegate = self
        
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
        
        // Initialize an instance of Contacts Search Results Controller
        let resultsVC = ContactsSearchResultsController()
        
        // set ourself as the contact selector delegate to receive 
        // callbacks from ContactsSearchResultController
        resultsVC.contactSelector = self
        
        // and update the contacts attribute with the fetched results controller
        resultsVC.contacts = fetchedResultsController?.fetchedObjects as! [Contact]
        
        // initialize our search controller with the instance of the Contacts Search Results Controller
        searchController = UISearchController(searchResultsController: resultsVC)
        // we update the search results updater attribute also to be the resultsVC
        searchController?.searchResultsUpdater = resultsVC
        
        // and allow the searchcontroller to dynamically present itself over the Contacts VC
        definesPresentationContext = true
        
        // update the table header view with our search controller search bar
        tableView.tableHeaderView = searchController?.searchBar
        
    }
    

    func newContact() {
        // instantiate a new CN Contact VC
        let newContactVC = CNContactViewController(forNewContact: nil)
        // set the delegate attribute of the new VC to ourself to receive callbacks
        newContactVC.delegate = self
        // push the new VC onto the Nav stack
        navigationController?.pushViewController(newContactVC, animated: true)
    }
    
    
    func selectedContact(contact: Contact) {
        // confirm the contact has a contact ID
        guard let id = contact.contactID else { return }
        
        // generate a Contact Store instance
        let store = CNContactStore()
        // and a Contact constant
        let cnContact: CNContact
        
        // use a do-catch statement to attempt to create a contact from our store
        do {
            cnContact = try store.unifiedContactWithIdentifier(id, keysToFetch: [CNContactViewController.descriptorForRequiredKeys()])
        } catch {
            return
        }
        
        // instantiate a ContactsUI Contact VC for the Contact
        let vc = CNContactViewController(forContact: cnContact)
        // hide the tab bar
        vc.hidesBottomBarWhenPushed = true
        
        // push the Contact VC into the Navigation stack to present it
        navigationController?.pushViewController(vc, animated: true)
        
        // and deactivate the search controller
        searchController?.active = false
    }

}


extension ContactsViewController: UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return fetchedResultsController?.sections?.count ?? 0
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sections = fetchedResultsController?.sections else { return 0 }
        let currentSection = sections[section]
        return currentSection.numberOfObjects
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath)
        configureCell(cell, atIndexPath: indexPath)
        return cell
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let sections = fetchedResultsController?.sections else { return nil }
        let currentSection = sections[section]
        return currentSection.name
    }
}


extension ContactsViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, shouldHighlightRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        guard let contact = fetchedResultsController?.objectAtIndexPath(indexPath) as? Contact else { return }
        selectedContact(contact)
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}


extension ContactsViewController: TableViewFetchedResultsDisplayer {
    
    func configureCell(cell: UITableViewCell, atIndexPath indexPath: NSIndexPath) {
        guard let contact = fetchedResultsController?.objectAtIndexPath(indexPath) as? Contact
            else { return }
        cell.textLabel?.text = contact.fullName
    }
}


extension ContactsViewController: CNContactViewControllerDelegate {
    
    func contactViewController(viewController: CNContactViewController, didCompleteWithContact contact: CNContact?) {
        // if the user cancelled (no contact) - pop the view controller and return
        if contact == nil {
            navigationController?.popViewControllerAnimated(true)
            return
        }
    }
    
}
