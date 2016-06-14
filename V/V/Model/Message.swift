//
//  Message.swift
//  V
//
//  Created by Dulio Denis on 5/15/16.
//  Copyright © 2016 Dulio Denis. All rights reserved.
//

import Foundation
import CoreData


class Message: NSManagedObject {

// Insert code here to add functionality to your managed object subclass
    
    // our isIncoming attribute to work with the CoreData incoming NSNumber
    
    var isIncoming: Bool {
        // will return true if sender exists - otherwise false
        // meaning if we are the sender then its outgoing and false
        return sender != nil
    }

}
