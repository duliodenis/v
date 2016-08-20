//
//  FavoritesViewController.swift
//  V
//
//  Created by Dulio Denis on 7/26/16.
//  Copyright © 2016 Dulio Denis. All rights reserved.
//

import UIKit
import CoreData
import Contacts
import ContactsUI

class FavoritesViewController: UIViewController, TableViewFetchedResultsDisplayer, ContextViewController {

    var context: NSManagedObjectContext?
    private var fetchedResultsController: NSFetchedResultsController?
    private var fetchedResultsDelegate: NSFetchedResultsControllerDelegate?
    
    private let tableView = UITableView(frame: CGRectZero, style: .Plain)
    private let cellIdentifier = "FavoriteCell"
    
    private let store = CNContactStore()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Favorites"
        
        navigationItem.leftBarButtonItem = editButtonItem()
        
        automaticallyAdjustsScrollViewInsets = false
        tableView.registerClass(FavoriteCell.self, forCellReuseIdentifier: cellIdentifier)
        tableView.tableFooterView = UIView(frame: CGRectZero)
        
        tableView.dataSource = self
        tableView.delegate = self
        
        fillViewWith(tableView)
        
        // confirm we have a context
        if let context = context {
            // set a fetch request for our contact instances
            let request = NSFetchRequest(entityName: "Contact")
            
            // constrain the request with a predicate that only pulls contact instances
            // where the favorite attribute is true
            // and are only available in Firebase (ie: having storageIDs)
            request.predicate = NSPredicate(format: "storageID != nil AND favorite = true")
            
            // set-up sort descriptors for last name and first name
            request.sortDescriptors = [NSSortDescriptor(key: "lastName", ascending: true),
                                       NSSortDescriptor(key: "firstName", ascending: true)]
            
            // generate the fetched results controller instance using the request and context
            fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
            
            // use the tableview fetched results delegate with out tableview to set the delegate
            fetchedResultsDelegate = TableViewFetchedResultsDelegate(tableView: tableView, displayer: self)
            fetchedResultsController?.delegate = fetchedResultsDelegate
            
            // use a do-catch statement to attempt to perform a fetch on the fetched results controller
            do {
                try fetchedResultsController?.performFetch()
            } catch {
                print("FavoritesVC: There was a problem fetching.")
            }
        }
    }
    
    
    override func setEditing(editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        
        if editing {
            tableView.setEditing(true, animated: true)
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Delete All", style: .Plain, target: self, action: "deleteAll")
        } else {
            tableView.setEditing(false, animated: true)
            navigationItem.rightBarButtonItem = nil
            guard let context = context where context.hasChanges else {return}
            
            do {
                try context.save()
            } catch {
                print("FavoritesViewController: Error Saving Favorites.")
            }
        }
    }
    
    
    func deleteAll() {
        guard let contacts = fetchedResultsController?.fetchedObjects as? [Contact] else {return}
        
        for contact in contacts {
            context?.deleteObject(contact)
        }
    }
    
    
    func configureCell(cell: UITableViewCell, atIndexPath indexPath: NSIndexPath) {
        // get the relevant contact back from the fetched results controller 
        // using the object at index path method
        guard let contact = fetchedResultsController?.objectAtIndexPath(indexPath) as? Contact else {return}
        
        // use a guard statement to confirm the cell is a favorite cell
        guard let cell = cell as? FavoriteCell else {return}
        
        // if it is update the textlabel, detail text label, phone type label
        cell.textLabel?.text = contact.fullName
        cell.detailTextLabel?.text = contact.status ?? "*** No Status ***"

        // Show the the first of its kind and ignore the registered attribute
        // cell.phoneTypeLabel.text = contact.phoneNumbers?.allObjects.first?.kind
        
        // get the contact phone numbers attribute and filter the Set
        cell.phoneTypeLabel.text = contact.phoneNumbers?.filter({
            // get the number in the closure
            number in
            // confirm it is a PhoneNumber type
            guard let number = number as? PhoneNumber else {return false}
            // and return the registered numbers
            return number.registered
        // only getting the first's kind (mobile, home, etc)
        }).first?.kind
        
        // add an accessory type using the Detail Button enum type
        cell.accessoryType = .DetailButton
    }
    
}


extension FavoritesViewController: UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return fetchedResultsController?.sections?.count ?? 0
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sections = fetchedResultsController?.sections else {return 0}
        let currentSection = sections[section]
        return currentSection.numberOfObjects
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath)
        configureCell(cell, atIndexPath: indexPath)
        return cell
    }
    
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let sections = fetchedResultsController?.sections else {return nil}
        let currentSection = sections[section]
        return currentSection.name
    }
    
}


extension FavoritesViewController: UITableViewDelegate {

    func tableView(tableView: UITableView, shouldHighlightRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        guard let contact = fetchedResultsController?.objectAtIndexPath(indexPath) as? Contact else {return}
        let chatContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        chatContext.parentContext = context
        
        let chat = Chat.existing(directWith: contact, inContext: chatContext) ?? Chat.new(directWith: contact, inContext: chatContext)
        
        let vc = ChatViewController()
        vc.context = chatContext
        vc.chat = chat
        vc.hidesBottomBarWhenPushed = true
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(tableView: UITableView, accessoryButtonTappedForRowWithIndexPath indexPath: NSIndexPath) {
        guard let contact = fetchedResultsController?.objectAtIndexPath(indexPath) as? Contact else {return}
        guard let id = contact.contactID else {return}
        
        let cnContact: CNContact
        
        do {
            cnContact = try store.unifiedContactWithIdentifier(id, keysToFetch: [CNContactViewController.descriptorForRequiredKeys()])
        } catch {
            return
        }
        
        let vc = CNContactViewController(forContact: cnContact)
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        guard let contact = fetchedResultsController?.objectAtIndexPath(indexPath) as? Contact else {return}
        contact.favorite = false
    }
    
}