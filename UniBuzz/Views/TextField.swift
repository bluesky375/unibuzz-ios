//
//  TextField.swift
//  UniBuzz
//
//  Created by Gourav on 05/11/19.
//  Copyright © 2019 unibuss. All rights reserved.
//

import UIKit

class TextField: UITextField {
    let padding = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
    
    override func awakeFromNib() {
        self.layer.borderColor = UIColor.init(hex: "#3745A3").cgColor
        self.layer.cornerRadius = 3
        self.layer.borderWidth = 1
    }
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
}
