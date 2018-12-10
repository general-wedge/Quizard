//
//  ViewHelper.swift
//  Quizard
//
//  Created by Xcode User on 2018-12-08.
//  Copyright © 2018 Xcode User. All rights reserved.
//

import Foundation
import UIKit

class ViewHelper {
    
    static func applyButtonStyles(button: UIButton) {
        button.backgroundColor = .clear
        button.layer.cornerRadius = button.frame.height / 2
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.white.cgColor
    }
    
    static func applyInputStyles(input: UITextField) {
        let width = CGFloat(2.0)
        let border = CALayer()
        border.borderColor = UIColor.white.cgColor
        border.frame = CGRect(x: 0, y: input.frame.size.height - width, width:  input.frame.size.width, height: input.frame.size.height)
        
        border.borderWidth = width
        input.borderStyle = UITextField.BorderStyle.none
        input.layer.addSublayer(border)
        input.layer.masksToBounds = true
    }
    
    static func applyLabelStyles(label: UILabel, text: String) {
        label.text = text
        label.textColor = UIColor.white
        label.font = UIFont(name: "Optima-Bold", size: 20)
    }
    
    static func applyCellLabelStyles(label: UILabel?, text: String) {
        if let cellLabel = label {
            cellLabel.text = text
            cellLabel.sizeToFit()
            cellLabel.textColor = UIColor.white
            cellLabel.font = UIFont(name: "Optima-Bold", size: 20)
            cellLabel.textAlignment = .center
        }
    }
}
