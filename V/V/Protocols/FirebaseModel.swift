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