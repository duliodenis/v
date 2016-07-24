//
//  ContextSyncManager.swift
//  V
//
//  Created by Dulio Denis on 7/24/16.
//  Copyright © 2016 Dulio Denis. All rights reserved.
//
//  Job of this Class is to maintain the main context syned with the background context

import UIKit
import CoreData

class ContextSyncManager: NSObject {

    private var mainContext: NSManagedObjectContext
    private var backgroundContext: NSManagedObjectContext
    
    init(mainContext: NSManagedObjectContext, backgroundContext: NSManagedObjectContext) {
        self.mainContext = mainContext
        self.backgroundContext = backgroundContext
        
        super.init()
        
        // Add two observers to watch for Save Notifications to the main and background contexts
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("mainContextSaved:"), name: NSManagedObjectContextDidSaveNotification, object: mainContext)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("backgroundContextSaved:"), name: NSManagedObjectContextDidSaveNotification, object: backgroundContext)
    }
    
    
    func mainContextSaved(notification: NSNotification) {
        backgroundContext.performBlock({
            self.backgroundContext.mergeChangesFromContextDidSaveNotification(notification)
        })
    }
    
    
    func backgroundContextSaved(notification: NSNotification) {
        mainContext.performBlock({
            self.mainContext.mergeChangesFromContextDidSaveNotification(notification)
        })
    }
    
}
