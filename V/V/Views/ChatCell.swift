//
//  ChatCell.swift
//  V
//
//  Created by Dulio Denis on 5/15/16.
//  Copyright © 2016 Dulio Denis. All rights reserved.
//

import UIKit

class ChatCell: UITableViewCell {
    
    let nameLabel = UILabel()
    let messageLabel = UILabel()
    let dateLabel = UILabel()

    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        // stylize the labels a bit
        nameLabel.font = UIFont(name: "AdventPro-Light", size: 18)
        messageLabel.textColor = UIColor(red: 149/255, green: 165/255, blue: 166/255, alpha: 1)
        dateLabel.textColor = UIColor(red: 149/255, green: 165/255, blue: 166/255, alpha: 1)
        
        // setup an array with our three label instances
        let labels = [nameLabel, messageLabel, dateLabel]
        // iterate through the label array
        for label in labels {
            // turn off translates autoresizing mask into contstraint
            label.translatesAutoresizingMaskIntoConstraints = false
            // and add to the content view
            contentView.addSubview(label)
        }
        
        // setup constraints in an array for activation
        let constraints: [NSLayoutConstraint] = [
            // setup the name label to be constraint to the top anchor and leading anchor of the content view
            nameLabel.topAnchor.constraintEqualToAnchor(contentView.layoutMarginsGuide.topAnchor),
            nameLabel.leadingAnchor.constraintEqualToAnchor(contentView.layoutMarginsGuide.leadingAnchor),
            
            // constrain the message label to the bottom of the content view and the same leading anchor as the name label
            messageLabel.bottomAnchor.constraintEqualToAnchor(contentView.layoutMarginsGuide.bottomAnchor),
            messageLabel.leadingAnchor.constraintEqualToAnchor(nameLabel.leadingAnchor),
            
            // constrain the date label to the trailing anchor of the content view 
            // and align to the first base line anchor of the name label
            dateLabel.trailingAnchor.constraintEqualToAnchor(contentView.layoutMarginsGuide.trailingAnchor),
            dateLabel.firstBaselineAnchor.constraintEqualToAnchor(nameLabel.firstBaselineAnchor)
        ]
        
        // activate the constraints with the constraint array
        NSLayoutConstraint.activateConstraints(constraints)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
