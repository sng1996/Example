//
//  EditPoint.swift
//  Example
//
//  Created by Сергей Гаврилко on 27.10.17.
//  Copyright © 2017 Сергей Гаврилко. All rights reserved.
//

import UIKit

class EditPoint: NSObject {
    
    var title: String = ""
    var icon: UIImage!
    var name: String = ""
    
    init(title: String, icon: UIImage, name: String){
        self.title = title
        self.icon = icon
        self.name = name
    }

}
