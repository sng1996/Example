//
//  Filter.swift
//  Smart-as
//
//  Created by Сергей Гаврилко on 05.08.17.
//  Copyright © 2017 Сергей Гаврилко. All rights reserved.
//

import UIKit

class Filter: NSObject, NSCopying {
    
    var science: Int = 0
    var type: Int = 0
    var isSortDown: Bool = false
    var sort: Int = 0
    var minCost: Int = 0
    var maxCost: Int = 0
    
    override init(){}
    
    init(science: Int, type: Int, isSortDown: Bool, sort: Int, minCost: Int, maxCost: Int){
        self.science = science
        self.type = type
        self.isSortDown = isSortDown
        self.sort = sort
        self.minCost = minCost
        self.maxCost = maxCost
    }
    
    func copy(with zone: NSZone? = nil) -> Any{
        
        let copy = Filter(science: science, type: type, isSortDown: isSortDown, sort: sort, minCost: minCost, maxCost: maxCost)
        return copy
        
    }

}
