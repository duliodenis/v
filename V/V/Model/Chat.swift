//
//  Chat.swift
//  V
//
//  Created by Dulio Denis on 5/15/16.
//  Copyright © 2016 Dulio Denis. All rights reserved.
//

import Foundation
import CoreData


class Chat: NSManagedObject {

// Insert code here to add functionality to your managed object subclass
    
    // Last Message Optional Computed Attribute
    
    var lastMessage: Message? {
        // setup a fetch request for Message instances
        let request = NSFetchRequest(entityName: "Message")
        // constrain the request with a predicate which specifies 
        // that we only want Messages for the current chat instance
        request.predicate = NSPredicate(format: "chat = %@", self)
        // set a sort descriptor to use the timestamp of the message in descending order
        request.sortDescriptors = [NSSortDescriptor(key: "timestamp", ascending: false)]
        // only need 1 (the last one)
        request.fetchLimit = 1
        
        // execute the request using a do {} catch
        do {
            // execute the request on the managed object context returning an array of Messages
            guard let results = try self.managedObjectContext?.executeFetchRequest(request) as? [Message]
                // returning nil if we get nothing which is fine since we specified an optional
                else { return nil }
            // otherwise if we get anything back return the first one
            return results.first
        } catch {
            print("Error for request.")
        }
        
        return nil
    }
    
    
    // add a participant to the chat - takes a participant as an argument
    
    func add(participant contact: Contact) {
        // add to the participants attribute the contact parameter
        mutableSetValueForKey("participants").addObject(contact)
    }
    
}
