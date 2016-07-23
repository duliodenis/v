//
//  ContactSelector.swift
//  V
//
//  Created by Dulio Denis on 7/23/16.
//  Copyright © 2016 Dulio Denis. All rights reserved.
//

import Foundation

protocol ContactSelector {
    
    // tells us which contact was selected
    func selectedContact(contact: Contact)

}