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
}


// Conforming to this protocol will require implementing the configure cell method

protocol TableViewFetchedResultsDisplayer {
    
    // the Configure Cell Helper Method takes a UITableViewCell and an indexPath
    func configureCell(cell: UITableViewCell, atIndexPath: NSIndexPath)
}