//
//  NewGroupViewController.swift
//  V
//
//  Created by Dulio Denis on 6/18/16.
//  Copyright © 2016 Dulio Denis. All rights reserved.
//

import UIKit
import CoreData

class NewGroupViewController: UIViewController {
    
    var context: NSManagedObjectContext?
    // set this when we create our new instance of our VC
    var chatCreationDelegate: ChatCreationDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "New Group"
    }
    
}
