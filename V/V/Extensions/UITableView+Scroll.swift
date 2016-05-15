//
//  UITableView+Scroll.swift
//  V
//
//  Created by Dulio Denis on 4/18/16.
//  Copyright © 2016 Dulio Denis. All rights reserved.
//

import UIKit

extension UITableView {
    
    // Scroll a tableView down to the bottom
    func scrollToBottom() {
        // if the number of sections is greater than 1
        if self.numberOfSections > 1 {
            // then determine what the last section is
            let lastSection = self.numberOfSections - 1
            // generate an IndexPath for that last section
            let indexPath = NSIndexPath(forRow: self.numberOfRowsInSection(lastSection) - 1, inSection: lastSection)
            // and scroll to the bottom of that index path
            self.scrollToRowAtIndexPath(indexPath, atScrollPosition: .Bottom, animated: true)
        }
        
        // else scroll down if we have rows in the tableView and only one section
        else if numberOfRowsInSection(0) > 0 && self.numberOfSections == 1 {
            self.scrollToRowAtIndexPath(NSIndexPath(forRow: self.numberOfRowsInSection(0) - 1, inSection: 0), atScrollPosition: .Bottom, animated: true)
        }
    }
}
