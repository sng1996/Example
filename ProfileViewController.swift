//
//  ProfileViewController.swift
//  Smart-as
//
//  Created by Сергей Гаврилко on 05.08.17.
//  Copyright © 2017 Сергей Гаврилко. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var tableView1: UITableView!
    @IBOutlet var tableView2: UITableView!
    @IBOutlet var tableView3: UITableView!
    @IBOutlet var tableView4: UITableView!
    
    var pageIndex:Int = 0
    
    var performOrders: [Order] = []
    var orderedOrders: [Order] = []
    var historyOrders: [Order] = []
    var reviews: [Int] = []
    var tableViews: [UITableView] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        scrollView.delegate = self
        createSlides()
        setupScrollView(slides: tableViews)
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        let url = URL(string: way + "/order/my/?id=" + String(myId))
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
                        self.tableView1.reloadData()
                        self.tableView2.reloadData()
                        self.tableView3.reloadData()
                        self.tableView4.reloadData()
                    })
                }catch let error as NSError{
                    print(error)
                }
            }
        }).resume()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        tableView1.reloadData()
        tableView2.reloadData()
        tableView3.reloadData()
        tableView4.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section:Int) -> Int
    {
        if (tableView == tableView1){
            return performOrders.count
        }
        else if (tableView == tableView2){
            return orderedOrders.count
        }
        else if (tableView == tableView3){
            return historyOrders.count
        }
        else{
            return reviews.count
        }
        
    }
    
    public func tableView(_ tableView:UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "orderCell", for: indexPath) as! OrderTableViewCell
        
        switch tableView{
        case tableView1:
            cell.subject.text = performOrders[indexPath.row].subject
            cell.type.text = types[performOrders[indexPath.row].type]
            cell.cost.text = String(performOrders[indexPath.row].cost) + " ₽"
            cell.startDate.text = performOrders[indexPath.row].startDate
            cell.finishDate.text = performOrders[indexPath.row].finishDate
            break
        case tableView2:
            cell.subject.text = orderedOrders[indexPath.row].subject
            cell.type.text = types[orderedOrders[indexPath.row].type]
            cell.cost.text = String(orderedOrders[indexPath.row].cost) + " ₽"
            cell.startDate.text = orderedOrders[indexPath.row].startDate
            cell.finishDate.text = orderedOrders[indexPath.row].finishDate
            break
        case tableView3:
            cell.subject.text = historyOrders[indexPath.row].subject
            cell.type.text = types[historyOrders[indexPath.row].type]
            cell.cost.text = String(historyOrders[indexPath.row].cost) + " ₽"
            cell.startDate.text = historyOrders[indexPath.row].startDate
            cell.finishDate.text = historyOrders[indexPath.row].finishDate
            break
        case tableView4: break
        default: break
        }
        
        cell.tableView = tableView
       
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if (segue.identifier == "aboutOrder"){
            let DestViewController = segue.destination as! AboutOrderViewController
            let cell = sender as! OrderTableViewCell
            let indexPath = cell.tableView.indexPath(for: cell)!
            if (cell.tableView == tableView1){
                DestViewController.order = performOrders[indexPath.row].copy() as! Order
            }else if (cell.tableView == tableView2){
                DestViewController.order = orderedOrders[indexPath.row].copy() as! Order
            }else if (cell.tableView == tableView3){
                DestViewController.order = historyOrders[indexPath.row].copy() as! Order
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 66.0;
    }
    
    func createSlides(){
        
        tableViews.append(tableView1)
        tableViews.append(tableView2)
        tableViews.append(tableView3)
        tableViews.append(tableView4)
        
    }
    
    func setupScrollView(slides: [UITableView]){
        
        scrollView.contentSize = CGSize(width: view.frame.width * 4.0, height: scrollView.frame.size.height)
        scrollView.isPagingEnabled = true
        
        for i in 0..<4{
            tableViews[i].frame = CGRect(x: view.frame.width * CGFloat(i), y: 0, width: scrollView.frame.size.width, height: scrollView.frame.size.height)
            scrollView.addSubview(tableViews[i])
        }
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView){
        pageIndex = Int(round(scrollView.contentOffset.x/view.frame.width))
    }
    
    @IBAction func logout(){
        MessageManager.manager.logout(vc: self)
    }

}
