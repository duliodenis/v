//
//  FavoriteCell.swift
//  V
//
//  Created by Dulio Denis on 7/25/16.
//  Copyright © 2016 Dulio Denis. All rights reserved.
//

import UIKit

class FavoriteCell: UITableViewCell {

    let phoneTypeLabel = UILabel()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .Subtitle, reuseIdentifier: reuseIdentifier)
        
        // set some colors to the text labels
        detailTextLabel?.textColor = UIColor.lightGrayColor()
        phoneTypeLabel.textColor = UIColor.lightGrayColor()
        // update the translatesAutoresizingMaskIntoConstraints to use auto-layout
        phoneTypeLabel.translatesAutoresizingMaskIntoConstraints = false
        // add our phonetype label to the subview
        contentView.addSubview(phoneTypeLabel)
        
        // add centerY and trailing anchor constraints to phonetype label and activate
        phoneTypeLabel.centerYAnchor.constraintEqualToAnchor(contentView.centerYAnchor).active = true
        phoneTypeLabel.trailingAnchor.constraintEqualToAnchor(contentView.layoutMarginsGuide.trailingAnchor).active = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented.")
    }

}
