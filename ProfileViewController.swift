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
    @IBOutlet var myView: UIView!
    @IBOutlet var buttonView: UIView!
    @IBOutlet var btn1: UIButton!
    @IBOutlet var btn2: UIButton!
    @IBOutlet var btn3: UIButton!
    @IBOutlet var btn4: UIButton!
    @IBOutlet var nameLbl: UILabel!
    @IBOutlet var sectionNameLbl: UILabel!
    @IBOutlet var editBtn: UIButton!
    @IBOutlet var underStarsView: UIView!
    @IBOutlet var starsView: UIView!
    @IBOutlet var ratingView: UIView!
    
    var pageIndex:Int = 1
    
    var performOrders: [Order] = []
    var orderedOrders: [Order] = []
    var historyOrders: [Order] = []
    var reviews: [Review] = []
    
    var buttons: [UIButton] = []
    var buttonImgNames: [String] = ["Work", "Work_white", "Wait", "Wait_white", "History", "History_white", "Review", "Review_white"]
    var labels: [String] = ["Выполняемые работы", "Заказанные работы", "История всех заказов", "Рейтинг и отзывы"]
    
    var orders: [[Order]] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        for i in 0..<10{
            let order = Order(id: i, science: 0, type: 1, subject: "Аналитическая геометрия", cost: 100, startDate: "Вчера, 19:00", finishDate: "23.10, 19:00", des: "kek", customer: Profile(), performer: Profile(), status: 0)
            performOrders.append(order)
            orderedOrders.append(order)
            historyOrders.append(order)
            
        }
        
        for i in 0..<10{
            let review = Review(id: i, title: "Круто!!!", myText: "Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Nam liber te conscient to factor tum poen legum odioque civiuda.", name: "Scorpions", date: "20 авг.", rating: 3)
            reviews.append(review)
            
        }
            
            buttons = [self.btn1, self.btn2, self.btn3, self.btn4]
            
            buttons[0].setImage(UIImage(named: "Work"), for: .normal)
        
        orders.append(performOrders)
        orders.append(orderedOrders)
        orders.append(historyOrders)
        
        self.navigationController?.isNavigationBarHidden = true
        self.navigationController?.view.backgroundColor = .white
        self.navigationController?.navigationBar.barTintColor = .white
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
        
        buttonView.layer.borderColor = UIColor(red: 210/255.0, green: 210/255.0, blue: 210/255.0, alpha: 1.0).cgColor
        buttonView.layer.borderWidth = 0.5
        
        editBtn.layer.cornerRadius = 3
        
        underStarsView.layer.borderColor = UIColor(red: 210/255.0, green: 210/255.0, blue: 210/255.0, alpha: 1.0).cgColor
        underStarsView.layer.borderWidth = 0.5
        underStarsView.layer.cornerRadius = 15
        
        myView.frame.size.height -= ratingView.frame.height
    
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
            (cell as! OrderTableViewCell).setView()
        }
        else{
            cell = tableView.dequeueReusableCell(withIdentifier: "reviewCell", for: indexPath) as! ReviewTableViewCell
            (cell as! ReviewTableViewCell).textLbl.text = reviews[indexPath.row].myText
            (cell as! ReviewTableViewCell).titleLbl.text = reviews[indexPath.row].title
            (cell as! ReviewTableViewCell).dateLbl.text = reviews[indexPath.row].date
            //(cell as! ReviewTableViewCell).rating = reviews[indexPath.row].rating
            (cell as! ReviewTableViewCell).nameLbl.text = reviews[indexPath.row].name
            updateLabelFrame(label: (cell as! ReviewTableViewCell).textLbl)
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
        if (pageIndex == 4){
            return (checkHeight(myText: reviews[indexPath.row].myText))
        }
        return 85.0;
    }
    
    @IBAction func logout(){
        MessageManager.manager.logout(vc: self)
    }
    
    @IBAction func chabgePageIndex(sender: UIButton){
        
        pageIndex = sender.tag
        myTableView.reloadData()
        /*UIView.animate(withDuration: 0.3, delay: 0.1,
                       options: .curveEaseOut, animations: {
                        self.indicatorView.frame.origin.x = CGFloat(self.pageIndex-1)*self.indicatorView.frame.size.width
        }, completion: nil)*/
        
        sectionNameLbl.text = labels[pageIndex-1]
        
        if (pageIndex == 4){
            if (myView.frame.size.height < 300.0){
                myView.frame.size.height += ratingView.frame.height
            }
            ratingView.isHidden = false
        }
        else{
            if (myView.frame.size.height > 300.0){
                myView.frame.size.height -= ratingView.frame.height
            }
            ratingView.isHidden = true
        }
        
        for i in 0..<4{
            if (buttons[i] == sender){
                buttons[i].setImage(UIImage(named: buttonImgNames[i*2]), for: .normal)
            }
            else{
                buttons[i].setImage(UIImage(named: buttonImgNames[i*2 + 1]), for: .normal)
            }
        }
        
    }
    
    func updateLabelFrame(label: UILabel){
        label.numberOfLines = 20
        let maxSize = CGSize(width: 300, height: 200)
        let size = label.sizeThatFits(maxSize)
        label.frame = CGRect(origin: CGPoint(x: label.frame.origin.x, y: label.frame.origin.y), size: size)
    }
    
    func checkHeight(myText: String) -> CGFloat{
        
        var label: UILabel = UILabel()
        label.font = UIFont(name: ".HelveticaNeueDeskInterface-Regular", size: 15)!
        label.text = myText
        label.numberOfLines = 20
        let maxSize = CGSize(width: 300, height: 200)
        let size = label.sizeThatFits(maxSize)
        return size.height
    }

}
