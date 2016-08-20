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