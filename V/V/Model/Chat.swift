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
    
    
    // Computed attribute to determine whether this instance is a Group Chat
    
    var isGroupChat: Bool {
        return participants?.count > 1
    }
    
    
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
    
    
    // static function to check for a chat instance that matches the contact being passed in
    
    static func existing(directWith contact: Contact, inContext context: NSManagedObjectContext) -> Chat? {
        // generate a fetch request for our Chat instance
        let request = NSFetchRequest(entityName: "Chat")
        // set-up a predicate to constrain our request where we only get chat instances where the user
        // is the ONLY participant
        request.predicate = NSPredicate(format: "ANY PARTICIPANT = %@ AND participants.@count = 1", contact)
        
        // do a do-catch to execute the request
        do {
            // request returns an array of Chat instances
            guard let results = try context.executeFetchRequest(request) as? [Chat] else {return nil}
            // return the first item in the array of chat instances
            return results.first
        } catch {
            print("Chat: Error fetching request.")
        }
        // if we made it this far return nil
        return nil
    }
    
    
    // static function, callable on the Chat class, to generate new chat instances to Core Data
    
    static func new(directWith contact: Contact, inContext context: NSManagedObjectContext) -> Chat {
        // create a new instance of Chat with the insert New Object For Entity Name method
        let chat = NSEntityDescription.insertNewObjectForEntityForName("Chat", inManagedObjectContext: context) as! Chat
        // update the object by adding the contact as a participant
        chat.add(participant: contact)
        // return the newly created object
        return chat
    }
    
}
