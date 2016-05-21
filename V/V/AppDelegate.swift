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
        
        return true
    }
}

