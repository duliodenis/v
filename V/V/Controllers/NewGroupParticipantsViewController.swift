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
    
    // Used to search for contacts
    private var searchField: UITextField!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set the title
        title = "Add Participants"
    }
    
    
    // MARK: Private Helper Method for searchField
    
    private func createSearchField() -> UITextField {
        // instantiate a UITextField using a Frame with only a height of 50
        let searchField = UITextField(frame: CGRect(x: 0, y: 0, width: 0, height: 50))
        // set a background color to our new UITextField with a custom RGB
        searchField.backgroundColor = UIColor(red: 220/255, green: 220/255, blue: 220/225, alpha: 1)
        // set a placeholder
        searchField.placeholder = "Type contact name"
        
        // make a left side holder view and assign it to the searchField leftView attribute
        // with an .Always display mode
        let holderView = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        searchField.leftView = holderView
        searchField.leftViewMode = .Always
        
        // set up an image for our left side holder view ignoring the image asset's color
        let contactImage = UIImage(named: "contact_icon")?.imageWithRenderingMode(.AlwaysTemplate)
        // set up an ImageView to hold our image
        let contactImageView = UIImageView(image: contactImage)
        // and set a tint color on the image view since we removed the asset's color
        contactImageView.tintColor = UIColor.darkGrayColor()
        
        // Add our contactImageView as a subview to our holder view
        holderView.addSubview(contactImageView)
        
        // shutoff autoresizing mask translation into constrains so we can set them thru auto layout
        contactImageView.translatesAutoresizingMaskIntoConstraints = false
        
        // return our searchField
        return searchField
    }

}
