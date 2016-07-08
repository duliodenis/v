//
//  TableViewFetchedResultsDelegate.swift
//  V
//
//  Created by Dulio Denis on 5/28/16.
//  Copyright © 2016 Dulio Denis. All rights reserved.
//

import UIKit
import CoreData

class TableViewFetchedResultsDelegate: NSObject, NSFetchedResultsControllerDelegate {

    // tableView private instance attribute
    private var tableView: UITableView!
    // displayer private variable that conforms to the TableViewFetchedResultsDisplayer protocol
    private var displayer: TableViewFetchedResultsDisplayer!
    
    
    // custom initializer
    init(tableView: UITableView, displayer: TableViewFetchedResultsDisplayer) {
        // set up the two private attributes
        self.tableView = tableView
        self.displayer = displayer
    }
    
    
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        // start to expect changes to occur
        tableView.beginUpdates()
    }
    
    
    func controller(controller: NSFetchedResultsController, didChangeSection sectionInfo: NSFetchedResultsSectionInfo, atIndex sectionIndex: Int, forChangeType type: NSFetchedResultsChangeType) {
        
        // switch on the type of change
        switch type {
            
            // for inserts call the tableView insert sections method
        case .Insert:
            tableView.insertSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Fade)
            
            // for deletes call the tabelView delete sections method
        case .Delete:
            tableView.deleteSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Fade)
            
            // otherwise break
        default:
            break
        }
    }
    
    
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        
        // switch on type of change
        switch type {
            
            // for inserts call tableview insert rows at index path
        case .Insert:
            tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Fade)
            
            // for updates - get the cell, update it using the displayer, and reload the tableView
        case .Update:
            let cell = tableView.cellForRowAtIndexPath(indexPath!)
            displayer.configureCell(cell!, atIndexPath: indexPath!)
            tableView.reloadRowsAtIndexPaths([indexPath!], withRowAnimation: .Fade)
            
            // for moves - delete the cell from its original indexPath and add it to its new indexPath
        case .Move:
            tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Fade)
            tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Fade)
            
            // for deletes call the tableView delete rows at index path method
        case .Delete:
            tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Fade)
        }
    }
    
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        
        // once the contents changed let the tableView know to end updates
        tableView.endUpdates()
    }

}
