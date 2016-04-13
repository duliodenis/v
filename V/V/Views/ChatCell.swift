//
//  ChatCell.swift
//  V
//
//  Created by Dulio Denis on 4/13/16.
//  Copyright © 2016 Dulio Denis. All rights reserved.
//

import UIKit

class ChatCell: UITableViewCell {
    
    let messageLabel: UILabel = UILabel()
    private let bubbleImageView = UIImageView()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        // Setup message label and bubble image by turning off auto resizing mask into constraints
        // in order to specify constraints in code
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        bubbleImageView.translatesAutoresizingMaskIntoConstraints = false
        
        // add the speech bubble to the cell's contentView
        contentView.addSubview(bubbleImageView)
        // and the message label to the speech bubble
        bubbleImageView.addSubview(messageLabel)
        
        // Setup constraints for the message label
        // center the message view vertically and horizontally inside the speech bubble
        messageLabel.centerXAnchor.constraintEqualToAnchor(bubbleImageView.centerXAnchor).active = true
        messageLabel.centerYAnchor.constraintEqualToAnchor(bubbleImageView.centerYAnchor).active = true
        
        // and constraints for the speech bubble's height and width + 50 for the speech bubble handle
        bubbleImageView.widthAnchor.constraintEqualToAnchor(messageLabel.widthAnchor, constant: 50).active = true
        bubbleImageView.heightAnchor.constraintEqualToAnchor(messageLabel.heightAnchor).active = true
        
        // set the speech bubble's top and trailing anchors to be constrained to the contentView of the cell
        bubbleImageView.topAnchor.constraintEqualToAnchor(contentView.topAnchor).active = true
        bubbleImageView.trailingAnchor.constraintEqualToAnchor(contentView.trailingAnchor).active = true
        
        // set some specific message label text attributes
        messageLabel.textAlignment = .Center
        messageLabel.numberOfLines = 0 // use as many lines as it takes
        
        // get the speech bubble image
        let image = UIImage(named: "MessageBubble")?.imageWithRenderingMode(.AlwaysTemplate)
        bubbleImageView.tintColor = UIColor(red: 41.0/255.0, green: 128.0/255.0, blue: 185.0/255.0, alpha: 1)
        bubbleImageView.image = image
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
