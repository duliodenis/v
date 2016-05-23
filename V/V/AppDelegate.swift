//
//  AppDelegate.swift
//  V
//
//  Created by Dulio Denis on 4/11/16.
//  Copyright © 2016 Dulio Denis. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject : AnyObject]?) -> Bool {
        
        // set the root view controller to a navigation controller that has an embedded AllChatsVC
        let allChatsViewController = AllChatsViewController()
        let navigationController = UINavigationController(rootViewController: allChatsViewController)
        window!.rootViewController = navigationController
        
        // setup the context with the Main Queue Concurrency Type
        let context = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        
        // setup the coordinator using our CoreDataStack Singleton
        context.persistentStoreCoordinator = CoreDataStack.sharedInstance.coordinator
        
        // assign the context of the All Chats VC to this context we just setup
        allChatsViewController.context = context
        
        // Seed Data into Core Data
        seedData(context)
        
        return true
    }
    
    
    // MARK: Seed Data into Core Data
    
    func seedData(context: NSManagedObjectContext) {
        
        // check to see if we have a DataSeeded key in user defaults
        let dataSeeded = NSUserDefaults.standardUserDefaults().boolForKey("DataSeeded")
        // if we've already seeded data fall through and do not seed again
        guard !dataSeeded else { return }
        
        // create two people tuples of first and last names
        let people = [("Nicole", "Grey"), ("Kate", "Brenner")]
        // and insert two Contact entities out of these people into the Core Data  context
        for person in people {
            let contact = NSEntityDescription.insertNewObjectForEntityForName("Contact", inManagedObjectContext: context) as! Contact
            contact.firstName = person.0
            contact.lastName  = person.1
        }
        
        // save the context
        do {
            try context.save()
        } catch {
            print("Error saving contacts.")
        }
        
        // update user defaults with a true value for seeded data key
        NSUserDefaults.standardUserDefaults().setObject(true, forKey: "DataSeeded")
    }
}