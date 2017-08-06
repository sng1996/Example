//
//  Order.swift
//  Smart-as
//
//  Created by Сергей Гаврилко on 04.08.17.
//  Copyright © 2017 Сергей Гаврилко. All rights reserved.
//

import UIKit

class Order: NSObject, NSCopying {
    
    var id: Int = 0
    var science: Int = 0
    var type: Int = 0
    var subject: String = ""
    var cost: Int = 0
    var startDate: String = ""
    var finishDate: String = ""
    var des: String = ""
    var customer: Profile = Profile()
    var performer: Profile = Profile()
    
    override init(){}
    
    init(id: Int, science: Int, type: Int, subject: String, cost: Int, startDate: String, finishDate: String, des: String, customer: Profile, performer: Profile){
        self.id = id
        self.science = science
        self.type = type
        self.subject = subject
        self.cost = cost
        self.startDate = startDate
        self.finishDate = finishDate
        self.des = des
        self.customer = customer
        self.performer = performer
    }
    
    func copy(with zone: NSZone? = nil) -> Any{
        
        let copy = Order(id: id, science: science, type: type, subject: subject, cost: cost, startDate: startDate, finishDate: finishDate, des: des, customer: customer, performer: performer)
        return copy
        
    }

}
