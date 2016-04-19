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
        // Only scroll down if we have rows in the tableView
        if numberOfRowsInSection(0) > 0 {
            self.scrollToRowAtIndexPath(NSIndexPath(forRow: self.numberOfRowsInSection(0) - 1, inSection: 0), atScrollPosition: .Bottom, animated: true)
        }
    }
}
