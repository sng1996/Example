//
//  Profile.swift
//  Example
//
//  Created by Сергей Гаврилко on 06.08.17.
//  Copyright © 2017 Сергей Гаврилко. All rights reserved.
//

import UIKit

class Profile: NSObject {

    var id: Int = 0
    var email: String = ""
    var phone: String = ""
    var name: String = ""
    var password: String = ""
    var rating: Int = 0
    var balance: Int = 0
    
    override init(){}
    
    init(id: Int, email: String, phone: String, name: String, password: String, rating: Int, balance: Int){
        self.id = id
        self.email = email
        self.phone = phone
        self.name = name
        self.password = password
        self.rating = rating
        self.balance = balance
    }

    
}
