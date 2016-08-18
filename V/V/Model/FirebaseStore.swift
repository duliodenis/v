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
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    func hasAuth() -> Bool {
        return rootRef.authData != nil
    }
}