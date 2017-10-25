//
//  ExactScienceViewController.swift
//  Example
//
//  Created by Сергей Гаврилко on 04.10.17.
//  Copyright © 2017 Сергей Гаврилко. All rights reserved.
//

import UIKit

class ExactScienceViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var order: Order!
    var exactScience: [String] = ["Математический анализ"]
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
    
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.layer.dropBottomBorder()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.view.backgroundColor = .white
        self.navigationController?.navigationBar.barTintColor = .white
        self.navigationController?.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont(name: ".HelveticaNeueDeskInterface-Regular", size: 17)!]
        self.navigationController?.navigationBar.layer.setBottomBorder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    public func tableView(_ tableView:UITableView, numberOfRowsInSection section: Int) -> Int{
        
        return exactScience.count
        
    }
    
    public func tableView(_ tableView:UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "filterDataCell", for: indexPath) as! FilterDataTableViewCell
        cell.data.text = exactScience[indexPath.row]
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        return cell
        
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 53
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! FilterDataTableViewCell
        cell.myView.isHidden = false
    }
    
    public func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! FilterDataTableViewCell
        cell.myView.isHidden = true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let cell = sender as? FilterDataTableViewCell
        let indexPath = myTableView.indexPath(for: cell!)
        order.science = (indexPath?.row)!+1
        let nextViewController : CalendarViewController = segue.destination as! CalendarViewController
        nextViewController.order = order
    }

    
    @IBAction func back(){
        self.navigationController?.popViewController(animated: true)
    }

}
