//
//  TableViewFetchedResultsDisplayer.swift
//  V
//
//  Created by Dulio Denis on 7/8/16.
//  Copyright © 2016 Dulio Denis. All rights reserved.
//

import UIKit

// Conforming to this protocol will require implementing the configure cell method

protocol TableViewFetchedResultsDisplayer {
    
    // the Configure Cell Helper Method takes a UITableViewCell and an indexPath
    func configureCell(cell: UITableViewCell, atIndexPath indexPath: NSIndexPath)
}
