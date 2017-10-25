//
//  UITextFieldBottomBorder.swift
//  Example
//
//  Created by Сергей Гаврилко on 08.10.17.
//  Copyright © 2017 Сергей Гаврилко. All rights reserved.
//

import UIKit

extension CALayer {
    func setBottomBorder() {
        self.masksToBounds = false
        self.shadowColor = UIColor(red: 220/255.0, green: 220/255.0, blue: 220/255.0, alpha: 1.0).cgColor
        self.shadowOffset = CGSize(width: 0.0, height: 0.5)
        self.shadowOpacity = 1.0
        self.shadowRadius = 0.0
    }
    func dropBottomBorder(){
        self.shadowOpacity = 0.0
    }
}
