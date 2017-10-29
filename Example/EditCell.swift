//
//  EditCell.swift
//  Example
//
//  Created by Сергей Гаврилко on 27.10.17.
//  Copyright © 2017 Сергей Гаврилко. All rights reserved.
//

import UIKit

class EditCell: UITableViewCell {

    @IBOutlet var titleLbl: UILabel!
    @IBOutlet var icon: UIImageView!
    @IBOutlet var nameLbl: UILabel!
    
    func createLine(lenth: CGFloat){
        
        for i in 0..<Int(lenth/10.0){
            
            let line = UIView(frame: CGRect(x: 65 + i*10, y: Int(self.contentView.frame.size.height-1), width: 5, height: 1))
            line.backgroundColor = UIColor(red: (158/255.0), green: (171/255.0), blue: (205/255.0), alpha: 0.2)
            self.contentView.addSubview(line)
            
        }
        
    }
    
}
