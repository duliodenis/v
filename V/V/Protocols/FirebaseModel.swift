//
//  FirebaseModel.swift
//  V
//
//  Created by Dulio Denis on 8/20/16.
//  Copyright © 2016 Dulio Denis. All rights reserved.
//

import Foundation
import Firebase
import CoreData

protocol FirebaseModel {
    
    func upload(rootRef: Firebase, context: NSManagedObjectContext)
    
}


extension Contact: FirebaseModel {

    // upload contact instances from Firebase into our Core Data Model
    
    func upload(rootRef: Firebase, context: NSManagedObjectContext) {
        guard let phoneNumbers = phoneNumbers?.allObjects as? [PhoneNumber] else {return}
        
        for number in phoneNumbers {
            rootRef.childByAppendingPath("users").queryOrderedByChild("phoneNumber").queryEqualToValue(number.value).observeSingleEventOfType(.Value, withBlock: {
                snapshot in
                
                guard let user = snapshot.value as? NSDictionary else {return}
                
                let uid = user.allKeys.first as? String
                context.performBlock {
                    self.storageID = uid
                    number.registered = true
                    
                    do {
                        try context.save()
                    } catch {
                        print("Contact: FirebaseModel extension (Problem Saving)")
                    }
                }
            })
        }
    }
    
    
    func observeStatus(rootRef: Firebase, context: NSManagedObjectContext) {
        // create a Firebase location for the user using the storage ID
        // specifying we want to look at the status
        // for the observation we specify we want to observe changes to the value
        // when there is a change to this value the block will fire
        rootRef.childByAppendingPath("users/"+storageID!+"/status").observeEventType(.Value, withBlock: {
            snapshot in
            // we get the status back using the snapshot value attribute
            // and confirm its a String
            guard let status = snapshot.value as? String else {return}
            
            // update our status inside a perform block for safety
            context.performBlock {
                self.status = status
                
                do {
                    // save the update to Core Data
                    try context.save()
                } catch {
                    print("Contact Observing Status Error Saving.")
                }
            }
        })
    }
    
}


extension Chat: FirebaseModel {
    
    func upload(rootRef: Firebase, context: NSManagedObjectContext) {
        // confirm the storageID is nil - meaning its not on Firebase
        guard storageID == nil else {return}
        // create a ref for our chats using a new location to store the keypath
        let ref = rootRef.childByAppendingPath("chats").childByAutoId()
        // update the storageID to use the ref key
        storageID = ref.key
        
        // set-up a data dictionary using id as the key and the ref.key as the value
        var data: [String:AnyObject] = [
            "id": ref.key,
        ]
        
        // get our participants into an array
        guard let participants = participants?.allObjects as? [Contact] else {return}
        // get phone numbers
        var numbers = [FirebaseStore.currentPhoneNumber!: true]
        // and an array of user ids
        var userIDs = [rootRef.authData.uid]
        
        for participant in participants {
            guard let phoneNumbers = participant.phoneNumbers?.allObjects as? [PhoneNumber] else {continue}
            guard let number = phoneNumbers.filter({$0.registered}).first else {continue}
            numbers[number.value!] = true
            userIDs.append(participant.storageID!)
        }
        
        data["participants"] = numbers
        
        if let name = name {
            data["name"] = name
        }
        
        ref.setValue(["meta": data])
        
        for id in userIDs {
            rootRef.childByAppendingPath("users/"+id+"/chats/"+ref.key).setValue(true)
        }
    }
    
}


extension Message: FirebaseModel {
    
    func upload(rootRef: Firebase, context: NSManagedObjectContext) {
        
        // ensure the message's chat is on Firebase - if it is not then upload that now
        if chat?.storageID == nil {
            chat?.upload(rootRef, context: context)
        }
        
        // generate a data dictionary with two key value pairs
        let data = [
            // the message
            "message": text!,
            // and the sender using the current phone number attribute
            "sender" : FirebaseStore.currentPhoneNumber!
        ]
        
        // create a guard statement to check our chat, timestamp and storage id attributes
        guard let chat = chat, timestamp = timestamp, storageID = chat.storageID else {return}
        // create a time stamp attribute using 100K to remove any decimals for Firebase
        let timeInterval = String(Int(timestamp.timeIntervalSince1970 * 100000))
        // set the ref path for the messages and using the time interval as the value
        rootRef.childByAppendingPath("chats/"+storageID+"/messages/"+timeInterval).setValue(data)
    }
    
}