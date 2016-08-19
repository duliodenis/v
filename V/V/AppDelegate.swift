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
    
    // private optional contact importer
    private var contactImporter: ContactImporter?
    
    // private optional context sync manager for Contact syncing
    private var contactsSyncer: ContextSyncManager?
    
    // private optional context sync manager for remote Contact syncing
    private var contactsUploadSyncer: ContextSyncManager?
    
    // private optional context sync manager for Firebase syncing
    private var firebaseSyncer: ContextSyncManager?
    
    // private optional for our Remote Firebase Store
    private var firebaseStore: FirebaseStore?
    
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject : AnyObject]?) -> Bool {
        
        // setup the main App context with the Main Queue Concurrency Type
        let mainContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        
        // setup the coordinator using our CoreDataStack Singleton
        mainContext.persistentStoreCoordinator = CoreDataStack.sharedInstance.coordinator
        
        // setup a Private Dispatch Queue Context for the Contacts to work in its own thread
        let contactsContext = NSManagedObjectContext(concurrencyType: .PrivateQueueConcurrencyType)
        // setup the persistent store coordinator for the contacts context
        contactsContext.persistentStoreCoordinator = CoreDataStack.sharedInstance.coordinator
        
        // setup a Private Dispatch Queue Context for the Firebase Context to work in its own thread
        let firebaseContext = NSManagedObjectContext(concurrencyType: .PrivateQueueConcurrencyType)
        // setup the persistent store coordinator for the Firebase context
        firebaseContext.persistentStoreCoordinator = CoreDataStack.sharedInstance.coordinator
        
        // initialize the Firebase Store
        let firebaseStore = FirebaseStore(context: firebaseContext)
        self.firebaseStore = firebaseStore
        
        // initialize contacts remote upload syncer with main context and firebase context
        contactsUploadSyncer = ContextSyncManager(mainContext: mainContext, backgroundContext: firebaseContext)
        contactsUploadSyncer?.remoteStore = firebaseStore
        
        // initialize firebase remote syncer with main context and firebase context
        firebaseSyncer = ContextSyncManager(mainContext: mainContext, backgroundContext: firebaseContext)
        firebaseSyncer?.remoteStore = firebaseStore
        
        // initialize contacts syncer with main context and contacts context
        contactsSyncer = ContextSyncManager(mainContext: mainContext, backgroundContext: contactsContext)
        
        // initialize contact importer
        contactImporter = ContactImporter(context: contactsContext)
        
        // call the import contacts with this private queue context (pre-Firebase)
        // importContacts(contactsContext)
        
        // generate an instance of a tab bar controller
        let tabController = UITabBarController()
        
        // set-up an array of tuple instances of view controller data
        let vcData: [(UIViewController, UIImage, String)] = [
            (FavoritesViewController(), UIImage(named: "favorites_icon")!, "Favorites"),
            (ContactsViewController(), UIImage(named: "contact_icon")!, "Contacts"),
            (AllChatsViewController(), UIImage(named: "chat_icon")!, "Chats")
        ]
        
        // use map closure method to create an array of UINavigationController instances
        let viewControllers = vcData.map {
            (vc: UIViewController, image: UIImage, title: String) -> UINavigationController in
            // set-up the context of each ViewController using the ContextVC Protocol
            if var vc = vc as? ContextViewController {
                vc.context = mainContext
            }
            // for each nav controller we set its root VC
            let nav = UINavigationController(rootViewController: vc)
            // its image
            nav.tabBarItem.image = image
            // and its title
            nav.title = title
            // and return the NavController
            return nav
        }
        
        if firebaseStore.hasAuth() {
            firebaseStore.startSyncing()
            
            // listen for changes
            contactImporter?.listenForChanges()
            
            tabController.viewControllers = viewControllers
            window?.rootViewController = tabController
        } else {
            let vc = SignUpViewController()
            vc.remoteStore = firebaseStore
            vc.rootViewController = tabController
            vc.contactImporter = contactImporter
            window?.rootViewController = vc
        }
        
        return true
    }
    
    
    // MARK: Import Contacts into Core Data
    
    func importContacts(context: NSManagedObjectContext) {
        
        // check to see if we have a DataSeeded key in user defaults
        let dataSeeded = NSUserDefaults.standardUserDefaults().boolForKey("DataSeeded")
        // if we've already seeded data fall through and do not seed again
        guard !dataSeeded else { return }
        
        // fetch the user's contacts
        contactImporter?.fetch()
        
        // update user defaults with a true value for seeded data key
        NSUserDefaults.standardUserDefaults().setObject(true, forKey: "DataSeeded")
    }
}