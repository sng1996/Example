//
//  ProfileViewController.swift
//  Smart-as
//
//  Created by Сергей Гаврилко on 05.08.17.
//  Copyright © 2017 Сергей Гаврилко. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var myTableView: UITableView!
    @IBOutlet var walletBtn: UIButton!
    @IBOutlet var myView: UIView!
    @IBOutlet var buttonView: UIView!
    @IBOutlet var indicatorView: UIView!
    
    var pageIndex:Int = 1
    
    var performOrders: [Order] = []
    var orderedOrders: [Order] = []
    var historyOrders: [Order] = []
    var reviews: [Int] = []
    
    var orders: [[Order]] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        for i in 0..<10{
            let order = Order(id: i, science: 0, type: 1, subject: "Аналитическая геометрия", cost: 100, startDate: "Вчера, 19:00", finishDate: "23.10, 19:00", des: "kek", customer: Profile(), performer: Profile(), status: 0)
            performOrders.append(order)
            orderedOrders.append(order)
            historyOrders.append(order)
        }
        
        orders.append(performOrders)
        orders.append(orderedOrders)
        orders.append(historyOrders)
        
        self.navigationController?.isNavigationBarHidden = true
        self.navigationController?.view.backgroundColor = .white
        self.navigationController?.navigationBar.barTintColor = .white
        
        walletBtn.layer.borderWidth = 0.5
        walletBtn.layer.borderColor = UIColor(red: 210/255.0, green: 210/255.0, blue: 210/255.0, alpha: 1.0).cgColor
        
        myView.layer.shadowColor = UIColor.black.cgColor
        myView.layer.shadowOpacity = 0.1
        myView.layer.shadowOffset = CGSize.zero
        myView.layer.shadowRadius = 10
        myView.layer.cornerRadius = 5
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        /*let url = URL(string: way + "/order/my/?id=" + String(myId))
        URLSession.shared.dataTask(with: url!, completionHandler: {
            (data, response, error) in
            if(error != nil){
                print("error")
            }else{
                do{
                    self.performOrders.removeAll()
                    self.orderedOrders.removeAll()
                    self.historyOrders.removeAll()
                    let json = try JSONSerialization.jsonObject(with: data!, options:.allowFragments) as! [String : AnyObject]
                    let response = json["response"] as? [String: Any]
                    let arrNames = ["performed", "ordered", "history"]
    
                    
                    for i in 0..<3{
                        for elem in (response![arrNames[i]] as? [[String: Any]])!{
                            let data = elem as NSDictionary?
                            let customer = Profile()
                            customer.id = data?["client"] as! Int
                            let performer = Profile()
                            performer.id = data?["executor"] as! Int
                            let order = Order(id: data?["id"] as! Int, science: 0, type: data?["type"] as! Int, subject: data?["subject"] as! String, cost: data?["cost"] as! Int, startDate: data?["create_date"] as! String, finishDate: data?["end_date"] as! String, des: data?["description"] as! String, customer: customer, performer: performer, status: data?["status"] as! Int)
                            switch i {
                            case 0: self.performOrders.append(order)
                            case 1: self.orderedOrders.append(order)
                            case 2: self.historyOrders.append(order)
                            default: break
                            }
                        }
                    }
                    OperationQueue.main.addOperation({
                        //self.tableView1.reloadData()
                    })
                }catch let error as NSError{
                    print(error)
                }
            }
        }).resume()*/
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        myTableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section:Int) -> Int
    {
        if (pageIndex < 4){
            return orders[pageIndex-1].count
        }
        else{
            return reviews.count
        }
    }
    
    func tableView(_ tableView:UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        var cell: UITableViewCell!
        
        if (pageIndex < 4){
            cell = tableView.dequeueReusableCell(withIdentifier: "orderCell", for: indexPath) as! OrderTableViewCell
            
            (cell as! OrderTableViewCell).subject.text = performOrders[indexPath.row].subject
            (cell as! OrderTableViewCell).type.text = types[performOrders[indexPath.row].type]
            (cell as! OrderTableViewCell).cost.text = String(performOrders[indexPath.row].cost) + " ₽"
            (cell as! OrderTableViewCell).startDate.text = performOrders[indexPath.row].startDate
            (cell as! OrderTableViewCell).finishDate.text = performOrders[indexPath.row].finishDate
        }
        else{
            cell = tableView.dequeueReusableCell(withIdentifier: "orderCell", for: indexPath) as! OrderTableViewCell
        }

        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if (segue.identifier == "aboutOrder"){
            let DestViewController = segue.destination as! AboutOrderViewController
            let cell = sender as! OrderTableViewCell
            let indexPath = cell.tableView.indexPath(for: cell)!
            DestViewController.order = orders[pageIndex-1][indexPath.row].copy() as! Order
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 85.0;
    }
    
    @IBAction func logout(){
        MessageManager.manager.logout(vc: self)
    }
    
    @IBAction func chabgePageIndex(sender: UIButton){
        
        pageIndex = sender.tag
        myTableView.reloadData()
        UIView.animate(withDuration: 0.3, delay: 0.1,
                       options: .curveEaseOut, animations: {
                        self.indicatorView.frame.origin.x = CGFloat(self.pageIndex-1)*self.indicatorView.frame.size.width
        }, completion: nil)
        
    }

}
