//
//  AboutOrderViewController.swift
//  Smart-as
//
//  Created by Сергей Гаврилко on 05.08.17.
//  Copyright © 2017 Сергей Гаврилко. All rights reserved.
//

import UIKit

class AboutOrderViewController: UIViewController {
    
    @IBOutlet var type: UILabel!
    @IBOutlet var startDate: UILabel!
    @IBOutlet var finishDate: UILabel!
    @IBOutlet var cost: UILabel!
    @IBOutlet var des: UITextView!
    @IBOutlet var button: UIButton!
    @IBOutlet var navBarRightItem: UIBarButtonItem!
    
    var isMyOrder: Bool = false
    var order: Order!

    override func viewDidLoad() {
        super.viewDidLoad()

        type.text = types[order.type]
        startDate.text = order.startDate
        finishDate.text = order.finishDate
        cost.text = String(order.cost) + " ₽"
        des.text = order.des
        
        if (order.customer.id == myId){
            isMyOrder = true
            button.setTitle("Посмотреть исполнителей", for: .normal)
            navBarRightItem.isEnabled = true
            navBarRightItem.title = "options"
        }
        else{
            navBarRightItem.isEnabled = false
            navBarRightItem.title = ""
        }
        
    }
    
    @IBAction func actionSheet(sender: UIButton){
        
        if (isMyOrder){
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "ChoosePerformer") as! ChoosePerformerViewController
            nextViewController.order = order
            self.present(nextViewController, animated:true, completion:nil)
        }
        else{
            let formatter = DateFormatter()
            formatter.dateFormat = "dd/MM/yyyy hh:mm"
            let dateTmp = formatter.string(from: NSDate() as Date)
            let sheet = UIAlertController(title: "Выбери действие", message: nil, preferredStyle: .actionSheet)
            sheet.addAction(UIAlertAction(title: "Могу сделать", style: .default, handler: { _ in
                var request = URLRequest(url: URL(string: way + "/order/take")!)
                request.httpMethod = "POST"
                request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                let parameters = ["id": self.order.id, "executor": myId, "cost": self.order.cost, "date": dateTmp] as [String : Any]
                guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) else { return }
                request.httpBody = httpBody
                URLSession.shared.dataTask(with: request, completionHandler: {
                    (data, response, error) in
                    if(error != nil){
                        print("error")
                    }else{
                        do{
                            let json = try JSONSerialization.jsonObject(with: data!, options: []) as! [String : AnyObject]
                            let code = json["code"] as! Int
                            print(code)
                            self.dismiss(animated: true, completion: nil)
                        }catch let error as NSError{
                            print(error)
                        }
                    }
                }).resume()
        }))
            sheet.addAction(UIAlertAction(title: "Может договоримся?", style: .default, handler: { _ in
                
                
                let alertController: UIAlertController = UIAlertController(title: "Предложи свою цену", message: "", preferredStyle: .alert)
                
                //cancel button
                let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in
                    //cancel code
                }
                alertController.addAction(cancelAction)
                
                //ok button
                let nextAction: UIAlertAction = UIAlertAction(title: "Ok", style: .default) { action -> Void in
                    let text = (alertController.textFields?.first)?.text
                    
                    let formatter = DateFormatter()
                    formatter.dateFormat = "dd/MM/yyyy hh:mm"
                    let dateTmp = formatter.string(from: NSDate() as Date)
                    var request = URLRequest(url: URL(string: way + "/order/take")!)
                    request.httpMethod = "POST"
                    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                    let parameters = ["id": self.order.id, "executor": myId, "cost": Int(text!) ?? self.order.cost, "date": dateTmp] as [String : Any]
                    guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) else { return }
                    request.httpBody = httpBody
                    URLSession.shared.dataTask(with: request, completionHandler: {
                        (data, response, error) in
                        if(error != nil){
                            print("error")
                        }else{
                            do{
                                self.dismiss(animated: true, completion: nil)
                                
                            }catch let error as NSError{
                                print(error)
                            }
                        }
                    }).resume()

                }
                alertController.addAction(nextAction)
                
                //Add text field
                alertController.addTextField { (textField) -> Void in
                    textField.textColor = UIColor.black
                }
                //Present the AlertController
                self.present(alertController, animated: true, completion: nil)
            }))
            sheet.addAction(UIAlertAction(title: "Отмена", style: .cancel, handler: { _ in
                // Code to execute when "Cancel" is pressed
                print("Cancel selected")
            }))
            present(sheet, animated: true, completion: nil)
            
            
        }
        
    }
    
    @IBAction func options(){
        let sheet = UIAlertController(title: "Выбери действие", message: nil, preferredStyle: .actionSheet)
        sheet.addAction(UIAlertAction(title: "Редактировать заказ", style: .default, handler: { _ in
            // Code to execute when "Camera" is pressed
            print("Camera selected")
        }))
        sheet.addAction(UIAlertAction(title: "Удалить заказ", style: .destructive, handler: { _ in
            // Code to execute when "Gallery" is pressed
            print("Gallery selected")
        }))
        sheet.addAction(UIAlertAction(title: "Отмена", style: .cancel, handler: { _ in
            // Code to execute when "Cancel" is pressed
            print("Cancel selected")
        }))
        present(sheet, animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func unwindToHome(segue: UIStoryboardSegue) {}
    
    

}
