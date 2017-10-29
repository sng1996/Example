//
//  FilterDataViewController.swift
//  Smart-as
//
//  Created by Сергей Гаврилко on 04.08.17.
//  Copyright © 2017 Сергей Гаврилко. All rights reserved.
//

import UIKit

class FilterDataViewController: UIViewController{
    
    //VIEW
    
    @IBOutlet var tV: UITableView!
    
    //CONTROLLER
    
    var dataArr: [String]!
    var elementNum: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        designNavbar()
        
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let cell = sender as! FilterDataTableViewCell
        let indexPath = tV.indexPath(for: cell)!
        let DestViewController : FilterViewController = segue.destination as! FilterViewController
        
        if (elementNum == 1){
            DestViewController.scienceLbl.text = cell.data.text
            DestViewController.filter.science = indexPath.row
        } else{
            DestViewController.typeLbl.text = cell.data.text
            DestViewController.filter.type = indexPath.row
        }
        
    }
    
    //ACTION
    
    @IBAction func back(){
        self.navigationController?.popViewController(animated: true)
    }
    
    //DESIGN
    
    func designNavbar(){
        self.navigationController?.navigationBar.layer.dropBottomBorder()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.view.backgroundColor = .white
        self.navigationController?.navigationBar.barTintColor = .white
        self.navigationController?.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont(name: ".HelveticaNeueDeskInterface-Regular", size: 17)!]
        self.navigationController?.navigationBar.layer.setBottomBorder()
    }

}

extension FilterDataViewController: UITableViewDelegate, UITableViewDataSource{
    
    public func tableView(_ tableView:UITableView, numberOfRowsInSection section: Int) -> Int{
        return dataArr.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return 53.0;
    }
    
    public func tableView(_ tableView:UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "filterDataCell", for: indexPath) as! FilterDataTableViewCell
        
        cell.data.text = dataArr[indexPath.row]
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
}
