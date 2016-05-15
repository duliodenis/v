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
    
    // our isIncoming attribute to work with the CoreData incoming Boolean
    
    var isIncoming: Bool {
        get {
            // guard against no value by returning false
            guard let incoming = incoming else { return false }
            // otherwise return converted CoreData NSNumber value
            return incoming.boolValue
        }
        
        set(incoming) {
            self.incoming = incoming
        }
    }

}
