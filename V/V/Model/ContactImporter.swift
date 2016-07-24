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
    
    // Private optional time variable of last CNContact Notification
    private var lastCNContactNotificationTime: NSDate?
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    
    // MARK: Contact Authorization Change Add Observer
    //       Function Responsible for Listening for Changes to the Authorization to Contacts
    
    func listenForChanges() {
        // authorization status for Contacts
        CNContactStore.authorizationStatusForEntityType(.Contacts)
        // Add Observer for CNContactStoreDidChangeNotification and call adddressBookDidChange()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "addressBookDidChange:", name: CNContactStoreDidChangeNotification, object: nil)
    }
    
    
    func addressBookDidChange(notification: NSNotification) {
        // get current date and time
        let now = NSDate()
        // test if either last contact notification time is nil or if time interval is > than 1
        guard lastCNContactNotificationTime == nil || now.timeIntervalSinceDate(lastCNContactNotificationTime!) > 1 else { return }
        // update last notification time to now
        lastCNContactNotificationTime = now
        
        // fetch iOS Contacts
        fetch()
    }

    
    // MARK: Format Phone Numbers
    
    func formatPhoneNumber(number: CNPhoneNumber) -> String {
        return number.stringValue.stringByReplacingOccurrencesOfString(" ", withString: "").stringByReplacingOccurrencesOfString("-", withString: "").stringByReplacingOccurrencesOfString("(", withString: "").stringByReplacingOccurrencesOfString(")", withString: "")
    }
    
    
    // MARK: Private function to fetch both existing contacts and phone numbers as a tuple of dictionaries
    
    private func fetchExisting() -> (contacts: [String: Contact], phoneNumbers: [String: PhoneNumber]) {
        // initialize new contacts and phone number dictionaries
        var contacts = [String: Contact]()
        var phoneNumbers = [String: PhoneNumber]()
        
        // do-catch to request our contact instances from Core Data
        do {
            // instantiate a Core Data request for Contacts
            let request = NSFetchRequest(entityName: "Contact")
            // and specify a prefetch for related phoneNumbers
            request.relationshipKeyPathsForPrefetching = ["phoneNumbers"]
            // execute the request
            if let contactsResults = try self.context.executeFetchRequest(request) as? [Contact] {
                // iterate thru the contacts
                for contact in contactsResults {
                    // making contacts
                    contacts[contact.contactID!] = contact
                    // and phone numbers
                    for phoneNumber in contact.phoneNumbers! {
                        phoneNumbers[phoneNumber.value] = phoneNumber as? PhoneNumber
                    }
                }
            }
            
        } catch {
            print("Error")
        }
        // return contacts and phoneNumbers dictionaries as a tuple
        return (contacts, phoneNumbers)
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
                        // use tuple destructuring to get existing contacts and phone numbers
                        let (contacts, phoneNumbers) = self.fetchExisting()
                        
                        // make a fetch request for first name, last name, and phone
                        let request = CNContactFetchRequest(keysToFetch:
                            [CNContactGivenNameKey,
                                CNContactFamilyNameKey,
                                CNContactPhoneNumbersKey])
                        
                        // execute the request
                        try store.enumerateContactsWithFetchRequest(request, usingBlock: {
                            cnContact, stop in
                            
                            // make a Contact Core Data instance (if it doesn't already exisit)
                            guard let contact = contacts[cnContact.identifier] ?? NSEntityDescription.insertNewObjectForEntityForName("Contact", inManagedObjectContext: self.context) as? Contact else { return }
                            
                            // and use the CNContact attribute values for the new contact object
                            contact.firstName = cnContact.givenName
                            contact.lastName = cnContact.familyName
                            contact.contactID = cnContact.identifier
                            
                            // loop through the values in the cnContact phone numbers
                            for cnValue in cnContact.phoneNumbers {
                                // confirm the cnPhoneNumber exists
                                guard let cnPhoneNumber = cnValue.value as? CNPhoneNumber else { continue }
                                // confirm we can generate a Core Data phone number instance
                                // make a phoneNumber Core Data instance (if it doesn't already exist)
                                guard let phoneNumber = phoneNumbers[cnPhoneNumber.stringValue] ?? NSEntityDescription.insertNewObjectForEntityForName("PhoneNumber", inManagedObjectContext: self.context) as? PhoneNumber else { continue }
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
