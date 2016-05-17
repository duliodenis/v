//
//  MessageCell.swift
//  V
//
//  Created by Dulio Denis on 4/13/16.
//  Copyright © 2016 Dulio Denis. All rights reserved.
//

import UIKit

class MessageCell: UITableViewCell {
    
    let messageLabel: UILabel = UILabel()
    private let bubbleImageView = UIImageView()
    
    private var outgoingConstraints: [NSLayoutConstraint]!
    private var incomingConstraints: [NSLayoutConstraint]!
    
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
        bubbleImageView.heightAnchor.constraintEqualToAnchor(messageLabel.heightAnchor, constant: 20).active = true
        
        // set the speech bubble's top and trailing anchors constraints to those of the contentView of the cell with a margin
        bubbleImageView.topAnchor.constraintEqualToAnchor(contentView.topAnchor, constant: 10).active = true
        bubbleImageView.bottomAnchor.constraintEqualToAnchor(contentView.bottomAnchor, constant: -10).active = true
        
        // set the outgoing and incoming constraint arrays which will be activated based on the message type
        // ensuring it doesn't pass over the middle of the contentView of the cell
        outgoingConstraints = [
            bubbleImageView.trailingAnchor.constraintEqualToAnchor(contentView.trailingAnchor),
            bubbleImageView.leadingAnchor.constraintGreaterThanOrEqualToAnchor(contentView.centerXAnchor)
        ]
        
        incomingConstraints = [
            bubbleImageView.trailingAnchor.constraintLessThanOrEqualToAnchor(contentView.centerXAnchor),
            bubbleImageView.leadingAnchor.constraintEqualToAnchor(contentView.leadingAnchor)
        ]
        
        // set some specific message label text attributes
        messageLabel.font = UIFont(name: "AdventPro-Regular", size: 18)
        messageLabel.textColor = UIColor.whiteColor()
        messageLabel.textAlignment = .Center
        messageLabel.numberOfLines = 0 // use as many lines as it takes
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // based on the incoming bool parameter activate the appropriate incoming or outgoing constraint
    
    func incoming(incoming: Bool) {
        if incoming {
            NSLayoutConstraint.deactivateConstraints(outgoingConstraints)
            NSLayoutConstraint.activateConstraints(incomingConstraints)
            
            // set the speech bubble image
            bubbleImageView.image = bubble.incoming
            
        } else {
            NSLayoutConstraint.deactivateConstraints(incomingConstraints)
            NSLayoutConstraint.activateConstraints(outgoingConstraints)
            
            // set the speech bubble image
            bubbleImageView.image = bubble.outgoing
        }
    }
}


let bubble = makeBubble()


// make an incoming and a outgoing bubble tuple that is a flipped version with different color

func makeBubble() -> (incoming: UIImage, outgoing: UIImage) {
    let image = UIImage(named: "MessageBubble")!
    
    // Declare insets for Incoming and Outgoing speech bubbles to correct distortion
    let insetsIncoming = UIEdgeInsets(top: 17.0, left: 26.5, bottom: 17.5, right: 21.0)
    let insetsOutgoing = UIEdgeInsets(top: 17.0, left: 21.0, bottom: 17.5, right: 26.5)
    
    let outgoing = coloredImage(image, red: 41.0/255.0, green: 128.0/255.0, blue: 185.0/255.0, alpha: 0.7).resizableImageWithCapInsets(insetsOutgoing)
    
    let flippedImage = UIImage(CGImage: image.CGImage!, scale: image.scale, orientation: UIImageOrientation.UpMirrored)
    let incoming = coloredImage(flippedImage, red: 229.0/255.0, green: 229.0/255.0, blue: 229.0/255.0, alpha: 0.7).resizableImageWithCapInsets(insetsIncoming)
    
    return (incoming, outgoing)
}


func coloredImage(image: UIImage, red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) -> UIImage {
    // create a rectangle to work with
    let rect = CGRect(origin: CGPointZero, size: image.size)
    
    // create a bit-mapped image context in order to create the new image
    UIGraphicsBeginImageContextWithOptions(image.size, false, image.scale)
    let context = UIGraphicsGetCurrentContext()
    // tell the image to draw itself where the rectangle is
    image.drawInRect(rect)
    
    // set the fill color using the passed parameters, blend mode, and fill the rectangle
    CGContextSetRGBFillColor(context, red, green, blue, alpha)
    CGContextSetBlendMode(context, CGBlendMode.SourceAtop)
    CGContextFillRect(context, rect)
    
    // capture the image based on the updated context, then release the context, and return the image
    let result = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return result
}
