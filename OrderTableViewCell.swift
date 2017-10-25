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
    

}
