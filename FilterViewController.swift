//
//  FilterViewController.swift
//  Smart-as
//
//  Created by Сергей Гаврилко on 05.08.17.
//  Copyright © 2017 Сергей Гаврилко. All rights reserved.
//

import UIKit

class FilterViewController: UIViewController{

    @IBOutlet var scienceLbl: UILabel!
    @IBOutlet var typeLbl: UILabel!
    @IBOutlet var sw: UISwitch!
    @IBOutlet var view1: UIView!
    @IBOutlet var view2: UIView!
    @IBOutlet var view3: UIView!
    @IBOutlet var minCost: UITextField!
    @IBOutlet var maxCost: UITextField!
    @IBOutlet var applyBtn: UIButton!
    @IBOutlet var subjectBtn: UIButton!
    @IBOutlet var typeBtn: UIButton!
    @IBOutlet var sortBtn: UIButton!
    @IBOutlet var dateBtn: UIButton!
    @IBOutlet var costBtn: UIButton!
    @IBOutlet var timeBtn: UIButton!
    @IBOutlet var betweenBtn: UIButton!

    var viewArr: [UIView]!
    var filter: Filter = Filter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewArr = [view1, view2, view3]
        sw.addTarget(self, action:#selector(stateChanged(switchState:)), for: UIControlEvents.valueChanged)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        let customView = UIView(frame: CGRect(x: 0, y: 0, width: 320, height: 44))
        customView.backgroundColor = UIColor.white
        let continueBtn = UIButton(frame: CGRect(x: 190, y: 11, width: 110, height: 22))
        continueBtn.setTitle("Применить", for: .normal)
        continueBtn.setTitleColor(UIColor(red: (100/255.0), green: (64/255.0), blue: (111/255.0), alpha: 1), for: .normal)
        continueBtn.titleLabel?.font = UIFont(name: ".HelveticaNeueDeskInterface-Regular", size: 15)
        continueBtn.addTarget(self, action: #selector(apply), for: .touchUpInside)
        customView.addSubview(continueBtn)
        let photoBtn = UIButton(frame: CGRect(x: 15, y: 4, width: 40, height: 36))
        photoBtn.setImage(UIImage(named: "Keyboard"), for: .normal)
        photoBtn.addTarget(self, action: #selector(dismissKeyboard), for: .touchUpInside)
        let goImg = UIImageView(frame: CGRect(x: 300, y: 18.5, width: 6, height: 10))
        goImg.image = UIImage(named: "Go_color")
        customView.addSubview(goImg)
        customView.addSubview(photoBtn)
        customView.addSubview(continueBtn)
        customView.layer.borderColor = UIColor(red: (180/255.0), green: (180/255.0), blue: (180/255.0), alpha: 1).cgColor
        customView.layer.borderWidth = 0.5
        minCost.inputAccessoryView = customView
        maxCost.inputAccessoryView = customView
        
        let borderWidth: CGFloat = 0.5
        let borderColor = UIColor(red: (240/255.0), green: (240/255.0), blue: (240/255.0), alpha: 1).cgColor
        
        subjectBtn.layer.borderWidth = borderWidth
        typeBtn.layer.borderWidth = borderWidth
        sortBtn.layer.borderWidth = borderWidth
        dateBtn.layer.borderWidth = borderWidth
        costBtn.layer.borderWidth = borderWidth
        timeBtn.layer.borderWidth = borderWidth
        betweenBtn.layer.borderWidth = borderWidth
        subjectBtn.layer.borderColor = borderColor
        typeBtn.layer.borderColor = borderColor
        sortBtn.layer.borderColor = borderColor
        dateBtn.layer.borderColor = borderColor
        costBtn.layer.borderColor = borderColor
        timeBtn.layer.borderColor = borderColor
        betweenBtn.layer.borderColor = borderColor
        
        self.navigationController?.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont(name: ".HelveticaNeueDeskInterface-Regular", size: 17)!]
        
        setData()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.layer.dropBottomBorder()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.view.backgroundColor = .white
        self.navigationController?.navigationBar.barTintColor = .white
        self.navigationController?.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont(name: ".HelveticaNeueDeskInterface-Regular", size: 17)!]
        self.navigationController?.navigationBar.layer.setBottomBorder()
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
            viewArr[i].isHidden = true
        }
        viewArr[filter.sort].isHidden = false
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
            if self.view.frame.origin.y > 0{
                self.view.frame.origin.y -= (keyboardSize.height - applyBtn.frame.height)
                self.applyBtn.frame.origin.y += 2*applyBtn.frame.height
            }
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y < 0{
                self.view.frame.origin.y += (keyboardSize.height - applyBtn.frame.height)
                self.applyBtn.frame.origin.y -= 2*applyBtn.frame.height
            }
        }
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @IBAction func unwindToHome(segue: UIStoryboardSegue) {}
    
    @IBAction func pressSort(sender: UIButton){
        
        for i in 0..<3{
            viewArr[i].isHidden = true
        }
        
        viewArr[sender.tag].isHidden = false
        filter.sort = sender.tag
        
    }
    
    @IBAction func reset(sender: UIBarButtonItem){
        
        filter = Filter()
        setData()
        
    }
    
    func apply(){
        
    }
    
}
