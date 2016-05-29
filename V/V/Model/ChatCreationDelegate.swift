//
//  ChatCreationDelegate.swift
//  V
//
//  Created by Dulio Denis on 5/29/16.
//  Copyright © 2016 Dulio Denis. All rights reserved.
//

import Foundation
import CoreData

protocol ChatCreationDelegate {
    
    // Delegate has one method that takes a chat and a context
    func created(chat chat: Chat, inContext context: NSManagedObjectContext)
    
}