//
//  OrderTableViewCell.swift
//  Smart-as
//
//  Created by Сергей Гаврилко on 04.08.17.
//  Copyright © 2017 Сергей Гаврилко. All rights reserved.
//

import UIKit

class OrderTableViewCell: UITableViewCell {

    @IBOutlet var subject: UILabel!
    @IBOutlet var type: UILabel!
    @IBOutlet var cost: UILabel!
    @IBOutlet var startDate: UILabel!
    @IBOutlet var finishDate: UILabel!
    @IBOutlet var colorView: UIView!
    var tableView: UITableView!
    
    func setView(){
        
        type.sizeToFit()
        colorView.frame.size.width = 10 + type.frame.size.width + 10
        colorView.layer.borderColor = UIColor(red: 100/255.0, green: 64/255.0, blue: 111/255.0, alpha: 1.0).cgColor
        colorView.layer.borderWidth = 0.5
        colorView.layer.cornerRadius = 4
        
    }
    

}
