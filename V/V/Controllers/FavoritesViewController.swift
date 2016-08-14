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
    
    
    func configureCell(cell: UITableViewCell, atIndexPath indexPath: NSIndexPath) {
        // get the relevant contact back from the fetched results controller 
        // using the object at index path method
        guard let contact = fetchedResultsController?.objectAtIndexPath(indexPath) as? Contact else {return}
        
        // use a guard statement to confirm the cell is a favorite cell
        guard let cell = cell as? FavoriteCell else {return}
        
        // if it is update the textlabel, detail text label, phone type label
        cell.textLabel?.text = contact.fullName
        cell.detailTextLabel?.text = "*** No Status ***"
        cell.phoneTypeLabel.text = "mobile"
        
        // add an accessory type using the Detail Button enum type
        cell.accessoryType = .DetailButton
    }
    
}
