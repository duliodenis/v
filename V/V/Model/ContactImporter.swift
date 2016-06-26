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

class ContactImporter {
    
    private var context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
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
                        
                        // create an NSMutableSet to hold our contact phone numbers
                        let contactNumbers = NSMutableSet()
                        // loop through the values in the cnContact phone numbers
                        for cnValue in cnContact.phoneNumbers {
                            // confirm the cnPhoneNumber exists
                            guard let cnPhoneNumber = cnValue.value as? CNPhoneNumber else { continue }
                            // confirm we can generate a Core Data phone number instance
                            guard let phoneNumber = NSEntityDescription.insertNewObjectForEntityForName("PhoneNumber", inManagedObjectContext: self.context) as? PhoneNumber else { continue }
                            // update the value in Core Data by formating the cn phone number
                            phoneNumber.value = self.formatPhoneNumber(cnPhoneNumber)
                            // add the phone number to the NS Mutable Set of phone numbers
                            contactNumbers.addObject(phoneNumber)
                        }
                        // update the contact set to be the contact phone numbers 
                        contact.phoneNumbers = contactNumbers
                    })
                } catch let error as NSError {
                    print(error)
                } catch {
                    print("Error with request in do-catch")
                }
            }
        })
    }
    
}
