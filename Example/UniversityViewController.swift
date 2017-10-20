//
//  UniversityViewController.swift
//  Example
//
//  Created by Сергей Гаврилко on 04.10.17.
//  Copyright © 2017 Сергей Гаврилко. All rights reserved.
//

import UIKit

class UniversityViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var order: Order!
    var universities: [String] = ["МГТУ"]
    @IBOutlet var myTableView: UITableView!
    @IBOutlet var myTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.view.backgroundColor = .white
        self.navigationController?.navigationBar.barTintColor = .white
        myTextField.leftView = UIImageView(image: UIImage(named: "Search_gray"))
        myTextField.leftView?.frame = CGRect(x: 8, y: 8, width: 24, height:15)
        myTextField.leftView?.layoutMargins = UIEdgeInsetsMake(8, 8, 8, 0)
        myTextField.leftViewMode = .always
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    public func tableView(_ tableView:UITableView, numberOfRowsInSection section: Int) -> Int{
        return universities.count
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 53
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let cell = sender as? FilterDataTableViewCell
        let indexPath = myTableView.indexPath(for: cell!)
        //order.science = (indexPath?.row)!+1
        let nextViewController : CostViewController = segue.destination as! CostViewController
        nextViewController.order = order
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! FilterDataTableViewCell
        cell.myView.isHidden = false
    }
    
    public func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! FilterDataTableViewCell
        cell.myView.isHidden = true
    }
    
    public func tableView(_ tableView:UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "filterDataCell", for: indexPath) as! FilterDataTableViewCell
        cell.data.text = universities[indexPath.row]
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        return cell
        
    }
    
    @IBAction func back(){
        self.navigationController?.popViewController(animated: true)
    }
    

}
