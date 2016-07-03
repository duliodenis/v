//
//  ContactImporter.swift
//  V
//
//  Created by Dulio Denis on 6/22/16.
//  Copyright © 2016 Dulio Denis. All rights reserved.
//

import Foundation
import CoreData
import Contacts

class ContactImporter: NSObject {
    
    private var context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    
    // MARK: Contact Authorization Change Add Observer
    //       Function Responsible for Listening for Changes to the Authorization to Contacts
    
    func listenForChanges() {
        // authorization satus for Contacts
        CNContactStore.authorizationStatusForEntityType(.Contacts)
        // Add Observer for CNContactStoreDidChangeNotification and call adddressBookDidChange()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "addressBookDidChange:", name: CNContactStoreDidChangeNotification, object: nil)

    }
    
    
    func adddressBookDidChange(notification: NSNotification) {
        print(notification)
    }

    
    // MARK: Format Phone Numbers
    
    func formatPhoneNumber(number: CNPhoneNumber) -> String {
        return number.stringValue.stringByReplacingOccurrencesOfString(" ", withString: "").stringByReplacingOccurrencesOfString("-", withString: "").stringByReplacingOccurrencesOfString("(", withString: "").stringByReplacingOccurrencesOfString(")", withString: "")
    }
    
    
    // MARK: Fetch iOS Contacts
    
    func fetch() {
        // create an instance of our CN Contact Store
        let store = CNContactStore()
        
        // request access to our Contacts
        store.requestAccessForEntityType(.Contacts, completionHandler: {
            granted, error in
            
            // ensure this doesn't run on the main thread
            self.context.performBlock {
                // if access is granted by user
                if granted {
                    do {
                        // make a fetch request for first name, last name, and phone
                        let request = CNContactFetchRequest(keysToFetch:
                            [CNContactGivenNameKey,
                                CNContactFamilyNameKey,
                                CNContactPhoneNumbersKey])
                        
                        // execute the request
                        try store.enumerateContactsWithFetchRequest(request, usingBlock: {
                            cnContact, stop in
                            
                            // make a Contact Core Data instance
                            guard let contact = NSEntityDescription.insertNewObjectForEntityForName("Contact", inManagedObjectContext: self.context) as? Contact else { return }
                            
                            // and use the CNContact attribute values for the new contact object
                            contact.firstName = cnContact.givenName
                            contact.lastName = cnContact.familyName
                            contact.contactID = cnContact.identifier
                            
                            // loop through the values in the cnContact phone numbers
                            for cnValue in cnContact.phoneNumbers {
                                // confirm the cnPhoneNumber exists
                                guard let cnPhoneNumber = cnValue.value as? CNPhoneNumber else { continue }
                                // confirm we can generate a Core Data phone number instance
                                guard let phoneNumber = NSEntityDescription.insertNewObjectForEntityForName("PhoneNumber", inManagedObjectContext: self.context) as? PhoneNumber else { continue }
                                // update the value in Core Data by formating the cn phone number
                                phoneNumber.value = self.formatPhoneNumber(cnPhoneNumber)
                                // add the contact to the phoneNumber contact relationship for Core Data
                                phoneNumber.contact = contact
                            }
                        })
                        
                        // Save our context
                        try self.context.save()
                        
                    } catch let error as NSError {
                        print(error)
                    } catch {
                        print("Error with request in do-catch")
                    }
                }
            }
            
        })
    }
    
}
