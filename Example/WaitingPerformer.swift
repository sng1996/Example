//
//  WaitingPerformer.swift
//  Example
//
//  Created by Сергей Гаврилко on 13.09.17.
//  Copyright © 2017 Сергей Гаврилко. All rights reserved.
//

import UIKit

class WaitingPerformer: NSObject {
    
    var performer: Profile!
    var cost: Int = 0
    var date: String = ""
    
    override init(){}
    
    init(performer: Profile, cost: Int, date: String){
        self.performer = performer
        self.cost = cost
        self.date = date
    }

}
