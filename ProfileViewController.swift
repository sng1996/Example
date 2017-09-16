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
        
        let url = URL(string: way + "/order/perform/?id=" + String(myId))
        URLSession.shared.dataTask(with: url!, completionHandler: {
            (data, response, error) in
            if(error != nil){
                print("error")
            }else{
                do{
                    self.performOrders.removeAll()
                    let json = try JSONSerialization.jsonObject(with: data!, options:.allowFragments) as! [String : AnyObject]
                    let response = json["response"] as? [[String: Any]]
                    for elem in response!{
                        let data = elem as NSDictionary?
                        let customer = Profile()
                        customer.id = data?["client"] as! Int
                        let performer = Profile()
                        performer.id = data?["executor"] as! Int
                        let order = Order(id: data?["id"] as! Int, science: 0, type: data?["type"] as! Int, subject: data?["subject"] as! String, cost: data?["cost"] as! Int, startDate: data?["create_date"] as! String, finishDate: data?["end_date"] as! String, des: data?["description"] as! String, customer: customer, performer: performer)
                        
                        self.performOrders.append(order)
                    }
                    
                    /*OperationQueue.main.addOperation({
                     self.mainTableView.reloadData()
                     })*/
                    
                }catch let error as NSError{
                    print(error)
                }
            }
        }).resume()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        tableView1.reloadData()
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
        
        if (tableView == tableView1){
            print(performOrders)
            print(performOrders[indexPath.row])
            print(performOrders[indexPath.row].subject)
            //cell.subject.text = performOrders[indexPath.row].subject
            cell.subject.text = "Hello"
            cell.type.text = types[performOrders[indexPath.row].type]
            cell.cost.text = String(performOrders[indexPath.row].cost) + " ₽"
            cell.startDate.text = performOrders[indexPath.row].startDate
            cell.finishDate.text = performOrders[indexPath.row].finishDate
        }
        else{
            
        }
       
        return cell
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

}
