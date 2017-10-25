//
//  TypeViewController.swift
//  Example
//
//  Created by Сергей Гаврилко on 27.09.17.
//  Copyright © 2017 Сергей Гаврилко. All rights reserved.
//

import UIKit

class TypeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var order: Order = Order()
    @IBOutlet var myTableView: UITableView!
    @IBOutlet var alertView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont(name: ".HelveticaNeueDeskInterface-Regular", size: 17)!]
        
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
        // Dispose of any resources that can be recreated.
    }
    
    public func tableView(_ tableView:UITableView, numberOfRowsInSection section: Int) -> Int{
        
        return types.count-1
        
    }
    
    public func tableView(_ tableView:UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "filterDataCell", for: indexPath) as! FilterDataTableViewCell
        cell.data.text = types[indexPath.row+1]
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        return cell
        
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
        order.type = (indexPath?.row)!+1
        let nextViewController : ExactScienceViewController = segue.destination as! ExactScienceViewController
        nextViewController.order = order
    }
    
    @IBAction func close(){
        self.dismiss(animated: true, completion: nil)
    }

}
