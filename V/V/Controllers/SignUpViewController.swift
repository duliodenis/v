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
    
    var remoteStore: RemoteStore?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.flatPowderBlueColor()
        
        let label = UILabel()
        label.text = STRING_SIGNUP_TEXT
        label.font = UIFont(name: "AdventPro-Regular", size: 24)
        label.textColor = UIColor.flatWhiteColor()
        
        view.addSubview(label)
        
        let continueButton = CustomButton()
        continueButton.setTitle("Continue", forState: .Normal)
        continueButton.setTitleColor(UIColor.flatWhiteColor(), forState: .Normal)
        continueButton.titleLabel?.font = UIFont(name: "AdventPro-Regular", size: 24)
        continueButton.addTarget(self, action: "tappedContinue:", forControlEvents: .TouchUpInside)
        continueButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(continueButton)
        
        phoneNumberField.keyboardType = .PhonePad
        phoneNumberField.textColor = UIColor.flatWhiteColor()
        emailField.textColor = UIColor.flatWhiteColor()
        passwordField.textColor = UIColor.flatWhiteColor()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        let fields = [(phoneNumberField, "Phone Number"), (emailField, "Email"), (passwordField, "Password")]
        
        fields.forEach{
            $0.0.placeholder = $0.1
        }
        
        passwordField.secureTextEntry = true
        
        let stackView = UIStackView(arrangedSubviews: fields.map{$0.0})
        stackView.axis = .Vertical
        stackView.alignment = .Fill
        stackView.spacing = 20
        view.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        let constraints: [NSLayoutConstraint] = [
            label.topAnchor.constraintEqualToAnchor(topLayoutGuide.bottomAnchor, constant: 20),
            label.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor),
            stackView.topAnchor.constraintEqualToAnchor(label.bottomAnchor, constant: 20),
            stackView.leadingAnchor.constraintEqualToAnchor(view.layoutMarginsGuide.leadingAnchor),
            stackView.trailingAnchor.constraintEqualToAnchor(view.layoutMarginsGuide.trailingAnchor),
            continueButton.topAnchor.constraintEqualToAnchor(stackView.bottomAnchor, constant: 20),
            continueButton.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor),
            continueButton.widthAnchor.constraintEqualToAnchor(view.widthAnchor, constant: -75)
        ]
        
        NSLayoutConstraint.activateConstraints(constraints)
        phoneNumberField.becomeFirstResponder()
    }
    
    
    func tappedContinue(sender: UIButton) {
        guard let phoneNumber = phoneNumberField.text where phoneNumber.characters.count > 0 else {
            alertForError(STRING_PHONE_NUMBER_ERROR)
            return
        }
        
        guard let email = emailField.text where email.characters.count > 0 else {
            alertForError(STRING_EMAIL_ERROR)
            return
        }
        
        guard let password = passwordField.text where password.characters.count >= 6 else {
            alertForError(STRING_PASSWORD_ERROR)
            return
        }
        
        remoteStore?.signUp(phoneNumber: phoneNumber, email: email, password: password, success: {
            
            }, error: {
                errorString in
                
        })
    }
    
    
    private func alertForError(error: String) {
        let alertController = UIAlertController(title: "Error", message: error, preferredStyle: .Alert)
        let OKAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        
        alertController.addAction(OKAction)
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }

}
