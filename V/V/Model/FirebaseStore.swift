//
//  FirebaseStore.swift
//  V
//
//  Created by Dulio Denis on 8/18/16.
//  Copyright © 2016 Dulio Denis. All rights reserved.
//

import Foundation
import Firebase
import CoreData

class FirebaseStore {
    
    private let context: NSManagedObjectContext
    private let rootRef = Firebase(url: FIREBASE_URL)
    
    private var currentPhoneNumber: String? {
        set(phoneNumber) {
            NSUserDefaults.standardUserDefaults().setObject(phoneNumber, forKey:"phoneNumber")
        }

        get {
            return NSUserDefaults.standardUserDefaults().objectForKey("phoneNumber") as? String
        }
    }
    
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    
    func hasAuth() -> Bool {
        return rootRef.authData != nil
    }
    
}

extension FirebaseStore: RemoteStore {
    
    func startSyncing() {
        
    }
    
    
    func store(inserted inserted: [NSManagedObject], updated: [NSManagedObject], deleted: [NSManagedObject]) {
        
    }
    
    
    func signUp(phoneNumber phoneNumber: String, email: String, password: String, success: () -> (), error errorCallback: (errorMessage: String) -> ()) {
        
        rootRef.createUser(email, password: password, withValueCompletionBlock: {
            error, result in
            
            if error != nil {
                errorCallback(errorMessage: error.description)
            } else {
                
                // generate a new user with a key-value pair of a phone number
                let newUser = [
                    "phoneNumber": phoneNumber
                ]
                
                // update our current phone number to persist in NSUserDefaults
                self.currentPhoneNumber = phoneNumber
                // get our Unique ID from the result
                let uid = result["uid"] as! String
                // set the rootRef/users/uid value = newUser
                self.rootRef.childByAppendingPath("users").childByAppendingPath(uid).setValue(newUser)
                // and authenticate the user
                self.rootRef.authUser(email, password: password, withCompletionBlock: {
                    error, authData in
                    
                    if error != nil {
                        errorCallback(errorMessage: error.description)
                    } else {
                        success()
                    }
                })
            }
            
        })
    }
    
}