//
//  ViewController.swift
//  Smart-as
//
//  Created by Сергей Гаврилко on 03.08.17.
//  Copyright © 2017 Сергей Гаврилко. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var mainTableView: UITableView!
    var filter: Filter = Filter()
    var tmpOrdersArr: [Order] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        MessageManager.manager.play()
        navigationController?.navigationBar.barTintColor = .white
        //updateData()
        
        tmpOrdersArr = NSArray(array:orders, copyItems: true) as! [Order]
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //updateData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        tmpOrdersArr = NSArray(array:orders, copyItems: true) as! [Order]
        
        if (filter.type != 0){
            tmpOrdersArr = tmpOrdersArr.filter { $0.type == filter.type }
        }
        
        if (filter.science != 0){
            tmpOrdersArr = tmpOrdersArr.filter { $0.science == filter.science }
        }
        
        if (filter.maxCost != 0){
            tmpOrdersArr = tmpOrdersArr.filter { $0.cost > filter.minCost && $0.cost < filter.maxCost}
        }
        
        switch filter.sort {
        case 0:
            if (filter.isSortDown){
                tmpOrdersArr.sort { $0.startDate > $1.startDate }
            }
            else{
                tmpOrdersArr.sort { $0.startDate < $1.startDate }
            }
            break
        case 1:
            if (filter.isSortDown){
                tmpOrdersArr.sort { $0.cost > $1.cost }
            }
            else{
                tmpOrdersArr.sort { $0.cost < $1.cost }
            }
            break
        case 2:
            if (filter.isSortDown){
                tmpOrdersArr.sort { $0.finishDate > $1.finishDate }
            }
            else{
                tmpOrdersArr.sort { $0.finishDate < $1.finishDate }
            }
            break
        default:
            break
        }
        mainTableView.reloadData()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 66.0;
    }
    
    public func tableView(_ tableView:UITableView, numberOfRowsInSection section: Int) -> Int{
        
        return tmpOrdersArr.count
        
    }
    
    public func tableView(_ tableView:UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "orderCell", for: indexPath) as! OrderTableViewCell
        
        cell.subject.text = tmpOrdersArr[indexPath.row].subject
        cell.type.text = types[tmpOrdersArr[indexPath.row].type]
        cell.cost.text = String(tmpOrdersArr[indexPath.row].cost) + " ₽"
        cell.startDate.text = tmpOrdersArr[indexPath.row].startDate
        cell.finishDate.text = tmpOrdersArr[indexPath.row].finishDate
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if (segue.identifier == "home"){
            let navVC : UINavigationController = segue.destination as! UINavigationController
            let DestViewController = navVC.viewControllers.first as! FilterViewController
            DestViewController.filter = filter.copy() as! Filter
        }
        if (segue.identifier == "aboutOrder"){
            let DestViewController = segue.destination as! AboutOrderViewController
            let cell = sender as! OrderTableViewCell
            let indexPath = mainTableView.indexPath(for: cell)!
            DestViewController.order = tmpOrdersArr[indexPath.row]
        }
    }
    
    @IBAction func unwindToHome(segue: UIStoryboardSegue) {}
    
    func updateData(){
        
        let url = URL(string: way + "/order/new/?user_id=" + String(myId))
        URLSession.shared.dataTask(with: url!, completionHandler: {
            (data, response, error) in
            if(error != nil){
                print("error")
            }else{
                do{
                    orders.removeAll()
                    let json = try JSONSerialization.jsonObject(with: data!, options:.allowFragments) as! [String : AnyObject]
                    let response = json["response"] as? [[String: Any]]
                    for elem in response!{
                        let data = elem as NSDictionary?
                        let customer = Profile()
                        customer.id = data?["client"] as! Int
                        let performer = Profile()
                        performer.id = data?["executor"] as! Int
                        let order = Order(id: data?["id"] as! Int, science: 0, type: data?["type"] as! Int, subject: data?["subject"] as! String, cost: data?["cost"] as! Int, startDate: data?["create_date"] as! String, finishDate: data?["end_date"] as! String, des: data?["description"] as! String, customer: customer, performer: performer, status: data?["status"] as! Int)
                        
                        orders.append(order)
                    }
                    
                    
                    OperationQueue.main.addOperation({
                     self.mainTableView.reloadData()
                    })
                    
                }catch let error as NSError{
                    print(error)
                }
            }
        }).resume()
    }
    
    @IBAction func updateView(){
        
        viewDidAppear(false)
        
    }
    

}

