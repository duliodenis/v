//
//  SignUpViewController.swift
//  V
//
//  Created by Dulio Denis on 8/16/16.
//  Copyright © 2016 Dulio Denis. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {
    
    private let phoneNumberField = UITextField()
    private let emailField = UITextField()
    private let passwordField = UITextField()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.flatWhiteColor()
        
        let label = UILabel()
        label.text = "Sign-Up to V"
        label.font = UIFont(name: "AdventPro-Regular", size: 24)
        
        view.addSubview(label)
        
        let continueButton = UIButton()
        continueButton.setTitle("Continue", forState: .Normal)
        continueButton.setTitleColor(UIColor.flatBlackColor(), forState: .Normal)
        continueButton.addTarget(self, action: "tappedContinue:", forControlEvents: .TouchUpInside)
        
        view.addSubview(continueButton)
    }
    
    
    func tappedContinue(sender: UIButton) {
        print("Continue Button Tapped")
    }

}
