//
//  NewGroupParticipantsViewController.swift
//  V
//
//  Created by Dulio Denis on 6/18/16.
//  Copyright © 2016 Dulio Denis. All rights reserved.
//

import UIKit
import CoreData

class NewGroupParticipantsViewController: UIViewController {
    
    var context: NSManagedObjectContext?
    var chat: Chat?
    // set this when we create our new instance of our VC
    var chatCreationDelegate: ChatCreationDelegate?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set the title
        title = "Add Participants"
    }

}
