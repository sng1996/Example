//
//  EnterViewController.swift
//  Example
//
//  Created by Сергей Гаврилко on 09.09.17.
//  Copyright © 2017 Сергей Гаврилко. All rights reserved.
//

import UIKit
import Paparazzo

class EnterViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    

    //ACTION
    
    @IBAction func enterUser(sender: UIButton){
        
        var code: Int = -1
        var request = URLRequest(url: URL(string:way + "/person/enter")!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let parameters = ["email": "nick" + String(sender.tag), "password": ""]
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
                    myId = json["id"] as! Int
                }catch{
                    print(error)
                }
            }
            
            if (code == 0){
                OperationQueue.main.addOperation({
                    let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                    let nextViewController = storyBoard.instantiateViewController(withIdentifier: "TabBarController") as! TabViewController
                    self.present(nextViewController, animated:true, completion:nil)
                })
            }
        
        }).resume()
    }
}
