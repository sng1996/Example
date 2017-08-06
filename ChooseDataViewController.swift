//
//  ChooseDataViewController.swift
//  Smart-as
//
//  Created by Сергей Гаврилко on 05.08.17.
//  Copyright © 2017 Сергей Гаврилко. All rights reserved.
//

import UIKit

class ChooseDataViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    var dataArr: [String]!
    var elementNum: Int = 0
    @IBOutlet var tV: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    public func tableView(_ tableView:UITableView, numberOfRowsInSection section: Int) -> Int{
        
        return dataArr.count
        
    }
    
    public func tableView(_ tableView:UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "filterDataCell", for: indexPath) as! FilterDataTableViewCell
        
        cell.data.text = dataArr[indexPath.row]
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let cell = sender as! FilterDataTableViewCell
        let indexPath = tV.indexPath(for: cell)!
        let DestViewController : AddViewController = segue.destination as! AddViewController
        
        if (elementNum == 1){
            DestViewController.scienceLbl.text = cell.data.text
            DestViewController.order.science = indexPath.row
        } else{
            DestViewController.typeLbl.text = cell.data.text
            DestViewController.order.type = indexPath.row
        }
    }
    
}
