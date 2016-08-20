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
    
    private(set) static var currentPhoneNumber: String? {
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
    
    
    private func upload(model: NSManagedObject) {
        guard let model = model as? FirebaseModel else {return}
        model.upload(rootRef, context: context)
    }
    
    
    private func fetchAppContacts() -> [Contact] {
        
        // use a do-catch statement to make a request for our Contact instances
        do {
            // set-up a fetch request for Contact instances
            let request = NSFetchRequest(entityName: "Contact")
            // constrain the results to those in Firebase
            request.predicate = NSPredicate(format: "storageID != nil")
            
            // get results back by executing the fetch request
            if let results = try self.context.executeFetchRequest(request) as? [Contact] {
                // and returning the results as an array of Contact instances
                return results
            }
            
        // otherwise print an error
        } catch {
            print("Firebase Store error fetching App Contacts.")
        }
        
        // and return an empty array
        return []
    }
    
}

extension FirebaseStore: RemoteStore {
    
    func startSyncing() {
        
    }
    
    
    func store(inserted inserted: [NSManagedObject], updated: [NSManagedObject], deleted: [NSManagedObject]) {
        inserted.forEach(upload)
        
        do {
            try context.save()
        } catch {
            print("FirebaseStore: RemoteStore error saving.")
        }
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
                FirebaseStore.currentPhoneNumber = phoneNumber
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