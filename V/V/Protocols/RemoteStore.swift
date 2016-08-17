//
//  RemoteStore.swift
//  V
//
//  Created by Dulio Denis on 8/17/16.
//  Copyright © 2016 Dulio Denis. All rights reserved.
//

import Foundation

protocol RemoteStore {
    
    func signUp(phoneNumber phoneNumber: String, email: String, password: String, success: ()->(), error: (errorMessage: String)->())
    
}