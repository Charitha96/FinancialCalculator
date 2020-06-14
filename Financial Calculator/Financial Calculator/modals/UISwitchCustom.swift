//
//  UISwitchCustom.swift
//  Financial Calculator
//
//  Created by Charitha Rajapakse on 3/10/20.
//  Copyright © 2020 Charitha Rajapakse. All rights reserved.
//
import UIKit
@IBDesignable

class UISwitchCustom: UISwitch {
    @IBInspectable var OffTint: UIColor? {
        didSet {
            self.tintColor = OffTint
            self.layer.cornerRadius = 16
            self.backgroundColor = OffTint
        }
    }
}
