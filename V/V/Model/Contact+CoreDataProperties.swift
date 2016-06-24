//
//  Contact+CoreDataProperties.swift
//  V
//
//  Created by Dulio Denis on 6/24/16.
//  Copyright © 2016 Dulio Denis. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Contact {

    @NSManaged var firstName: String?
    @NSManaged var lastName: String?
    @NSManaged var contactID: String?
    @NSManaged var chats: NSSet?
    @NSManaged var messages: NSSet?

}
