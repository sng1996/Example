//
//  AddViewController.swift
//  Smart-as
//
//  Created by Сергей Гаврилко on 05.08.17.
//  Copyright © 2017 Сергей Гаврилко. All rights reserved.
//

import UIKit

class AddViewController: UIViewController {

    @IBOutlet var scienceLbl: UILabel!
    @IBOutlet var typeLbl: UILabel!
    @IBOutlet var subjectTxtFld: UITextField!
    @IBOutlet var datePicker: UIDatePicker!
    @IBOutlet var costTxtFld: UITextField!
    @IBOutlet var desTxtView: UITextView!
    @IBOutlet var dateLbl: UILabel!
    
    var order: Order = Order()
    
    var isOpen: Bool = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        datePicker.backgroundColor = UIColor.white
        datePicker.addTarget(self, action: #selector(dateChanged(sender:)), for: .valueChanged)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target:self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)


    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if (segue.identifier == "sciences1" || segue.identifier == "types1"){
            
            let DestViewController : ChooseDataViewController = segue.destination as! ChooseDataViewController
            
            if (segue.identifier == "sciences1"){
                DestViewController.dataArr = NSArray(array:sciences, copyItems: true) as! [String]
                DestViewController.dataArr.remove(at: 0)
                DestViewController.elementNum = 1
            }
            else if(segue.identifier == "types1"){
                DestViewController.dataArr = NSArray(array:types, copyItems: true) as! [String]
                DestViewController.dataArr.remove(at: 0)
                DestViewController.elementNum = 2
            }
        }else{
            
            /*if sender is UIButton{
                
                order.subject = subjectTxtFld.text!
                order.finishDate = dateLbl.text!
                order.cost = Int(costTxtFld.text!)!
                order.des = desTxtView.text!
                
                let date = Date()
                let formatter = DateFormatter()
                formatter.dateFormat = "dd.MM.yyyy"
                order.startDate = formatter.string(from: date)
                
                //orders.append(order)
                
                var id_order:Int!
                
                var request = URLRequest(url: URL(string: way + "/order/create")!)
                request.httpMethod = "POST"
                request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                let parameters = ["subject": order.subject, "type": order.type, "category": order.science, "description": order.des, "create_date": order.startDate, "end_date": order.finishDate, "cost": order.cost, "client": myId] as [String : Any]
                guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) else { return }
                request.httpBody = httpBody
                URLSession.shared.dataTask(with: request, completionHandler: {
                    (data, response, error) in
                    
                    if let response = response{
                        print(response)
                    }
                    
                    if let data = data {
                        do{
                            let json = try JSONSerialization.jsonObject(with: data, options: []) as! [String : AnyObject]
                            id_order = json["id"] as! Int
                            print("HEEEEELLLLLLOOOOO!!!!!!!!" + String(json["code"] as! Int))
                        }catch{
                            print(error)
                        }
                    }
                    
                }).resume()
            }*/
            
        }
        
    }
    
    func dateChanged(sender: UIDatePicker){
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy hh:mm"
        dateLbl.text = formatter.string(from: datePicker.date)
        
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0{
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0{
                self.view.frame.origin.y += keyboardSize.height
            }
        }
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }


    
    @IBAction func unwindToHome(segue: UIStoryboardSegue) {}
    
    @IBAction func chooseDate(sender: UIButton){
        
        UIView.animate(withDuration: 0.5, animations: {
            if (self.isOpen){
                self.datePicker.frame.origin.y += 244
                self.isOpen = false
            } else{
                self.datePicker.frame.origin.y -= 244
                self.isOpen = true
            }
        }, completion: nil)
        
    }
    
    @IBAction func goBack(){
        order.subject = subjectTxtFld.text!
        order.finishDate = dateLbl.text!
        order.cost = Int(costTxtFld.text!)!
        order.des = desTxtView.text!
        
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        order.startDate = formatter.string(from: date)
        
        //orders.append(order)
        
        var id_order:Int!
        
        var request = URLRequest(url: URL(string: way + "/order/create")!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let parameters = ["subject": order.subject, "type": order.type, "category": order.science, "description": order.des, "create_date": order.startDate, "end_date": order.finishDate, "cost": order.cost, "client": myId] as [String : Any]
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) else { return }
        request.httpBody = httpBody
        URLSession.shared.dataTask(with: request, completionHandler: {
            (data, response, error) in
            
            if let response = response{
                print(response)
            }
            
            if let data = data {
                do{
                    let json = try JSONSerialization.jsonObject(with: data, options: []) as! [String : AnyObject]
                    id_order = json["id"] as! Int
                    self.dismiss(animated: true, completion: nil)
                }catch{
                    print(error)
                }
            }
            
        }).resume()
    }
    
}
