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
    
    private var outgoingConstraint: NSLayoutConstraint!
    private var incomingConstraint: NSLayoutConstraint!
    
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
        
        // set the speech bubble's top anchor to be constrained to the top of the contentView of the cell
        bubbleImageView.topAnchor.constraintEqualToAnchor(contentView.topAnchor).active = true
        
        // set the outgoing and incoming constraints which will be activated based on the message type
        outgoingConstraint = bubbleImageView.trailingAnchor.constraintEqualToAnchor(contentView.trailingAnchor)
        incomingConstraint = bubbleImageView.leadingAnchor.constraintEqualToAnchor(contentView.leadingAnchor)
        
        // set some specific message label text attributes
        messageLabel.textAlignment = .Center
        messageLabel.numberOfLines = 0 // use as many lines as it takes
        
        // get the speech bubble image
        let image = UIImage(named: "MessageBubble")?.imageWithRenderingMode(.AlwaysTemplate)
        bubbleImageView.tintColor = UIColor(red: 41.0/255.0, green: 128.0/255.0, blue: 185.0/255.0, alpha: 0.7)
        bubbleImageView.image = image
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // based on the incoming bool parameter activate the appropriate incoming or outgoing constraint
    
    func incoming(incoming: Bool) {
        if incoming {
            incomingConstraint.active = true
            outgoingConstraint.active = false
        } else {
            incomingConstraint.active = false
            outgoingConstraint.active = true
        }
    }
}
