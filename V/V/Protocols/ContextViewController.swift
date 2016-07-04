//
//  ContextViewController.swift
//  V
//
//  Created by Dulio Denis on 7/4/16.
//  Copyright © 2016 Dulio Denis. All rights reserved.
//

import Foundation
import CoreData


// Context View Controller Protocol to require classes to add a context attribute

protocol ContextViewController {
    // context attribute is both gettable and settable
    var context: NSManagedObjectContext? { get set }
}