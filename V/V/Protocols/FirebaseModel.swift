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