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
                        print(cnContact)
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
