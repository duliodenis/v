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
        
        // get access to the chat VC we will be displaying on the screen from the window attribute
        let chatViewController = window!.rootViewController as! ChatViewController
        
        // setup the context with the Main Queue Concurrency Type
        let context = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        
        // setup the coordinator using our CoreDataStack Singleton
        context.persistentStoreCoordinator = CoreDataStack.sharedInstance.coordinator
        
        // assign the context of the chat VC to this context we just setup
        chatViewController.context = context
        
        return true
    }
}

