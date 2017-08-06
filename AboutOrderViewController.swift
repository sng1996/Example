//
//  AboutOrderViewController.swift
//  Smart-as
//
//  Created by Сергей Гаврилко on 05.08.17.
//  Copyright © 2017 Сергей Гаврилко. All rights reserved.
//

import UIKit

class AboutOrderViewController: UIViewController {
    
    @IBOutlet var type: UILabel!
    @IBOutlet var startDate: UILabel!
    @IBOutlet var finishDate: UILabel!
    @IBOutlet var cost: UILabel!
    @IBOutlet var des: UITextView!
    
    var order: Order = Order()

    override func viewDidLoad() {
        super.viewDidLoad()

        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

}
