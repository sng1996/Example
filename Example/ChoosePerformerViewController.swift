//
//  ChoosePerformerViewController.swift
//  Example
//
//  Created by Сергей Гаврилко on 13.09.17.
//  Copyright © 2017 Сергей Гаврилко. All rights reserved.
//

import UIKit

class ChoosePerformerViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var order: Order!
    var performers: [WaitingPerformer] = []
    @IBOutlet var tV: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let url = URL(string: "https://fast-basin-97049.herokuapp.com/person/get_performers/?id=" + String(order.id))
        URLSession.shared.dataTask(with: url!, completionHandler: {
            (data, response, error) in
            if(error != nil){
                print("error")
            }else{
                do{
                    let json = try JSONSerialization.jsonObject(with: data!, options:.allowFragments) as! [String : AnyObject]
                    let response = json["response"] as? [[String: Any]]
                    for elem in response!{
                        let data = elem as NSDictionary?
                        let performer = Profile()
                        performer.id = data?["id"] as! Int
                        performer.name = data?["name"] as! String
                        performer.rating = data?["rating"] as! Int
                        let cost = data?["cost"] as! Int
                        let date = data?["date"] as! String
                        let perf = WaitingPerformer(performer: performer, cost: cost, date: date)
                        print(perf.performer.name)
                        self.performers.append(perf)
                    }
                    
                    
                    OperationQueue.main.addOperation({
                        //self.tV.reloadData()
                    })
                    
                }catch let error as NSError{
                    print(error)
                }
            }
        }).resume()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        tV.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    public func tableView(_ tableView:UITableView, numberOfRowsInSection section: Int) -> Int{
        
        return performers.count
        
    }
    
    public func tableView(_ tableView:UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "performerCell", for: indexPath) as! PerformerTableViewCell
        
        cell.name.text = performers[indexPath.row].performer.name
        cell.cost.text = String(performers[indexPath.row].cost)
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        

        let cell = sender as! PerformerTableViewCell
        let indexPath = tV.indexPath(for: cell)!
        let DestViewController : AboutOrderViewController = segue.destination as! AboutOrderViewController
        
        var code: Int = 0
        var request = URLRequest(url: URL(string: "https://fast-basin-97049.herokuapp.com/order/set_executor")!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let parameters = ["id": order.id, "executor": performers[indexPath.row].performer.id, "cost": performers[indexPath.row].cost]
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) else { return }
        request.httpBody = httpBody
        URLSession.shared.dataTask(with: request, completionHandler: {
            (data, response, error) in
            
            if let response = response{
                //print(response)
            }
            
            if let data = data {
                do{
                    let json = try JSONSerialization.jsonObject(with: data, options: []) as! [String : AnyObject]
                    code = json["code"] as! Int
                }catch{
                    print(error)
                }
            }
            
            if (code == 108){
                OperationQueue.main.addOperation({
                    self.order.cost = self.performers[indexPath.row].cost
                    self.order.performer = self.performers[indexPath.row].performer
                    DestViewController.order = self.order
                })
            }
            
        }).resume()
        
    }


}
