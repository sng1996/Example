//
//  FilterViewController.swift
//  Smart-as
//
//  Created by Сергей Гаврилко on 05.08.17.
//  Copyright © 2017 Сергей Гаврилко. All rights reserved.
//

import UIKit

class FilterViewController: UIViewController {

    @IBOutlet var scienceLbl: UILabel!
    @IBOutlet var typeLbl: UILabel!
    @IBOutlet var sw: UISwitch!
    @IBOutlet var img1: UIImageView!
    @IBOutlet var img2: UIImageView!
    @IBOutlet var img3: UIImageView!
    @IBOutlet var minCost: UITextField!
    @IBOutlet var maxCost: UITextField!

    var imgArr: [UIImageView]!
    var filter: Filter = Filter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imgArr = [img1, img2, img3]
        sw.addTarget(self, action:#selector(stateChanged(switchState:)), for: UIControlEvents.valueChanged)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target:self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        setData()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if (segue.identifier == "sciences" || segue.identifier == "types"){
        
            let DestViewController : FilterDataViewController = segue.destination as! FilterDataViewController
        
            if (segue.identifier == "sciences"){
                DestViewController.dataArr = sciences
                DestViewController.elementNum = 1
            }
            else if(segue.identifier == "types"){
                DestViewController.dataArr = types
                DestViewController.elementNum = 2
            }
            
        }
        
        else{
            
            if sender is UIButton{
                let btn: UIButton = sender as! UIButton
                if (btn.tag == 1){
                
                    filter.minCost = Int(minCost.text!)!
                    filter.maxCost = Int(maxCost.text!)!
                    let DestViewController : ViewController = segue.destination as! ViewController
                    DestViewController.filter = filter.copy() as! Filter
                }
            }
            
        }
        
    }
    
    func setData(){
        
        scienceLbl.text = sciences[filter.science]
        typeLbl.text = types[filter.type]
        sw.isOn = filter.isSortDown
        for i in 0..<3{
            imgArr[i].isHidden = true
        }
        imgArr[filter.sort].isHidden = false
        minCost.text = String(filter.minCost)
        maxCost.text = String(filter.maxCost)
        
    }
    
    func stateChanged(switchState: UISwitch){
        if switchState.isOn {
            filter.isSortDown = true
        } else {
            filter.isSortDown = false
        }
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
    
    @IBAction func pressSort(sender: UIButton){
        
        for i in 0..<3{
            imgArr[i].isHidden = true
        }
        
        imgArr[sender.tag].isHidden = false
        filter.sort = sender.tag
        
    }
    
    @IBAction func reset(sender: UIBarButtonItem){
        
        filter = Filter()
        setData()
        
    }
    
}
