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
        // iterate through the label arrary
        for label in labels {
            // turn off translates autoresizing mask into contstraint
            label.translatesAutoresizingMaskIntoConstraints = false
            // and add to the content view
            contentView.addSubview(label)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
