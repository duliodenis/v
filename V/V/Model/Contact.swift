//
//  Contact.swift
//  V
//
//  Created by Dulio Denis on 5/21/16.
//  Copyright © 2016 Dulio Denis. All rights reserved.
//

import Foundation
import CoreData


class Contact: NSManagedObject {

// Insert code here to add functionality to your managed object subclass
    
    
    // Computed Attribute to get the sort letter
    
    var sortLetter: String {
        // Access either the last name or first name's first character
        let letter = lastName?.characters.first ?? firstName?.characters.first
        // convert to to a string
        let letterString = String(letter!)
        // and return it
        return letterString
    }
    
    
    // Computed Attribute to get the full name
    
    var fullName: String {
        // initialize an empty string to start
        var fullName = ""
        
        // if we have a value in first name
        if let firstName = firstName {
            // then add the first name to the full name
            fullName += firstName
        }
        
        // if we have a last name value
        if let lastName = lastName {
            // then check to see if we have anything so far in full name
            if fullName.characters.count > 0 {
                // if we do put in a seperator space
                fullName += " "
            }
            // and finally add the last name value to full name
            fullName += lastName
        }
        
        // return the full name
        return fullName
    }

}
