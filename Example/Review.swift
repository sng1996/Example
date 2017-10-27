//
//  Review.swift
//  Example
//
//  Created by Сергей Гаврилко on 26.10.17.
//  Copyright © 2017 Сергей Гаврилко. All rights reserved.
//

import UIKit

class Review: NSObject {

    var id: Int = 0
    var title: String = ""
    var myText: String = ""
    var name: String = ""
    var date: String = ""
    var rating: Int = 0
    
    override init(){}
    
    init(id: Int, title: String, myText: String, name: String, date: String, rating: Int){
        self.id = id
        self.title = title
        self.myText = myText
        self.name = name
        self.date = date
        self.rating = rating
    }
    
}
