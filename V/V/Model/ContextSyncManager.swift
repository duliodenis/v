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
    
    var remoteStore: RemoteStore?
    
    
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
            
            let inserted = self.objectsForKey(NSInsertedObjectsKey, dictionary: notification.userInfo!, context: self.backgroundContext)
            
            let updated = self.objectsForKey(NSUpdatedObjectsKey, dictionary: notification.userInfo!, context: self.backgroundContext)
            
            let deleted = self.objectsForKey(NSDeletedObjectsKey, dictionary: notification.userInfo!, context: self.backgroundContext)
            
            self.backgroundContext.mergeChangesFromContextDidSaveNotification(notification)
            
            self.remoteStore?.store(inserted: inserted, updated: updated, deleted: deleted)
        })
    }
    
    
    func backgroundContextSaved(notification: NSNotification) {
        mainContext.performBlock({
            
            // use objects for key to properly fault objects
            self.objectsForKey(NSUpdatedObjectsKey, dictionary: notification.userInfo!, context: self.mainContext).forEach{$0.willAccessValueForKey(nil)
            }
            
            self.mainContext.mergeChangesFromContextDidSaveNotification(notification)
        })
    }
    
    
    private func objectsForKey(key: String, dictionary: NSDictionary, context: NSManagedObjectContext) -> [NSManagedObject] {
        // unwrap the dictionary by getting the value using the key parameter 
        // returning an empty array if there is no value
        guard let set = (dictionary[key] as? NSSet) else {return []}
        // if there are valid objects convert them to an arrayof NSManagedObjects
        guard let objects = set.allObjects as? [NSManagedObject] else {return []}
        // get the object from the context using the objectID attribute
        return objects.map{context.objectWithID($0.objectID)}
    }
    
}
