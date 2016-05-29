//
//  UIViewController+FillViewWith.swift
//  V
//
//  Created by Dulio Denis on 5/29/16.
//  Copyright © 2016 Dulio Denis. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func fillViewWith(subView: UIView) {
        
        // turn off auto resising mask so we can use constraints with our subView
        subView.translatesAutoresizingMaskIntoConstraints = false
        
        // add the subView as a subview
        view.addSubview(subView)
        
        // setup constraints for the subView
        let subViewConstraints: [NSLayoutConstraint] = [
            subView.topAnchor.constraintEqualToAnchor(topLayoutGuide.bottomAnchor),
            subView.leadingAnchor.constraintEqualToAnchor(view.leadingAnchor),
            subView.trailingAnchor.constraintEqualToAnchor(view.trailingAnchor),
            subView.bottomAnchor.constraintEqualToAnchor(bottomLayoutGuide.topAnchor)
        ]
        // and add the constraints
        NSLayoutConstraint.activateConstraints(subViewConstraints)
    }
    
}
