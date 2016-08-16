//
//  CustomButton.swift
//  V
//
//  Created by Dulio Denis on 8/16/16.
//  Copyright © 2016 Dulio Denis. All rights reserved.
//

import UIKit

class CustomButton: UIButton {
    
    override func awakeFromNib() {
        setupView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //        self.setupView()
    }
    
    func setupView() {
        layer.cornerRadius = 4.0
        backgroundColor = BUTTON_COLOR
        setTitleColor(UIColor.flatWhiteColor(), forState: .Normal)
    }
    
}